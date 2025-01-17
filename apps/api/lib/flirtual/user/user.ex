defmodule Flirtual.User do
  use Flirtual.Schema
  use Flirtual.Policy.Target, policy: Flirtual.User.Policy

  require Flirtual.Utilities
  import Flirtual.Utilities

  import Ecto.Changeset
  import Ecto.Query
  import Flirtual.Utilities

  alias Flirtual.User.Relationship
  alias Ecto.Changeset

  alias Flirtual.User.Profile.Image
  alias Flirtual.User.Profile.LikesAndPasses
  alias Flirtual.User.Profile.Block
  alias Flirtual.Subscription
  alias Flirtual.Discord
  alias Flirtual.Attribute
  alias Flirtual.User.ChangeQueue
  alias Flirtual.Report
  alias Flirtual.Repo
  alias Flirtual.Languages
  alias Flirtual.User
  alias Flirtual.User.Session

  @tags [:admin, :moderator, :beta_tester, :debugger, :verified, :legacy_vrlfp]

  schema "users" do
    field(:email, :string)
    field(:username, :string)
    field(:password_hash, :string, redact: true)
    field(:talkjs_id, :string, virtual: true)
    field(:talkjs_signature, :string, redact: true)
    field(:stripe_id, :string)
    field(:language, :string, default: "en")
    field(:visible, :boolean)
    field(:moderator_message, :string)
    field(:moderator_note, :string)

    field(:password, :string, virtual: true, redact: true)
    field(:relationship, :map, virtual: true)

    field(:tags, {:array, Ecto.Enum},
      values: @tags,
      default: []
    )

    field(:born_at, :date)
    field(:email_confirmed_at, :utc_datetime)
    field(:deactivated_at, :utc_datetime)
    field(:banned_at, :utc_datetime)
    field(:shadowbanned_at, :utc_datetime)
    field(:incognito_at, :utc_datetime)
    field(:active_at, :utc_datetime)

    has_many(:connections, Flirtual.Connection)
    has_many(:sessions, Flirtual.User.Session)

    has_one(:preferences, Flirtual.User.Preferences)
    has_one(:subscription, Subscription)
    has_one(:profile, Flirtual.User.Profile)

    timestamps()
  end

  def default_assoc do
    [
      subscription: Flirtual.Subscription.default_assoc(),
      connections: Flirtual.Connection.default_assoc(),
      preferences: Flirtual.User.Preferences.default_assoc(),
      profile: Flirtual.User.Profile.default_assoc()
    ]
  end

  def avatar_url(%User{} = user), do: avatar_url(user, 1980)

  def avatar_url(%User{} = user, size) when is_integer(size) do
    size = Integer.to_string(size)

    Enum.at(user.profile.images, 0)
    |> Image.url(
      scale_crop: ["#{size}x#{size}", :smart_faces_points],
      format: :auto,
      resize: "#{size}x",
      quality: :smart
    )
  end

  def avatar_thumbnail_url(%User{} = user), do: avatar_url(user, 64)

  def url(%User{} = user) do
    Application.fetch_env!(:flirtual, :frontend_origin)
    |> URI.merge("/#{user.username}")
  end

  def display_name(%User{} = user) do
    user.profile[:display_name] || user.username
  end

  def display_name(%User{id: user_id}, deleted: true) do
    "Deleted " <>
      (:crypto.hash(:sha, user_id)
       |> Base.encode16(case: :lower)
       |> String.slice(0..8))
  end

  def visible?(%User{} = user) do
    case visible(user) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end

  def visible(%User{} = user) do
    %{profile: profile} = user

    [
      {
        not is_nil(user.banned_at),
        %{reason: "account suspended"}
      },
      {
        not is_nil(user.deactivated_at),
        %{reason: "account deactivated", to: "/settings/deactivate"}
      },
      {
        not is_nil(user.incognito_at),
        %{reason: "account hidden"}
      },
      {
        # This validation should not be exposed to the end user,
        # We've temporarily disabled hiding it until we can find a better solution.
        not is_nil(user.shadowbanned_at),
        %{reason: "account shadow banned"}
      },
      # onboarding validations
      ## onboarding/1
      {
        Enum.empty?(filter_by(profile.preferences.attributes, :type, "gender")),
        %{reason: "missing gender preferences", to: "/onboarding/1"}
      },
      ## onboarding/2
      {
        is_nil(user.born_at),
        %{reason: "missing birthday", to: "/onboarding/2"}
      },
      {
        Enum.empty?(filter_by(profile.attributes, :type, "gender")),
        %{reason: "missing profile genders", to: "/onboarding/2"}
      },
      {
        Enum.empty?(profile.languages),
        %{reason: "missing profile languages", to: "/onboarding/2"}
      },
      {
        Enum.empty?(filter_by(profile.attributes, :type, "platform")),
        %{reason: "missing profile platforms", to: "/onboarding/2"}
      },
      {
        Enum.empty?(filter_by(profile.attributes, :type, "interest") ++ profile.custom_interests),
        %{reason: "missing profile interests", to: "/onboarding/2"}
      },
      ## onboarding/3
      {
        is_nil(profile.biography) or String.length(profile.biography) <= 48,
        %{reason: "profile biography too short", to: "/onboarding/3"}
      },
      {
        Enum.empty?(profile.images),
        %{reason: "missing profile pictures", to: "/onboarding/3"}
      },
      # email verification
      {
        is_nil(user.email_confirmed_at),
        %{reason: "email not verified", to: "/confirm-email"}
      }
    ]
    |> Enum.map_reduce(true, fn {condition, value}, acc ->
      if(condition and not Map.get(value, :silent, false),
        do: {value, false},
        else: {nil, if(acc, do: true, else: false)}
      )
    end)
    |> then(fn {errors, visible} ->
      errors = errors |> Enum.filter(&(not is_nil(&1)))
      if(visible, do: {:ok, user}, else: {:error, errors})
    end)
  end

  def preview(%User{} = user) do
    %{
      id: user.id,
      name: display_name(user),
      age: get_years_since(user.born_at),
      serious: user.profile.serious,
      dark: user.preferences.theme === :dark,
      avatar_url: avatar_url(user, 384),
      attributes:
        [
          if(user.preferences.privacy.country === :everyone and user.profile.country,
            do: Attribute.get(Atom.to_string(user.profile.country), "country"),
            else: nil
          )
          | user.profile.attributes
            |> Attribute.normalize_aliases()
            |> Enum.filter(&(&1.type in ["gender", "sexuality", "interest"]))
            |> Enum.map(
              &%{
                id: &1.id,
                type: &1.type,
                name: &1.name
              }
            )
        ]
        |> Enum.filter(&(not is_nil(&1)))
    }
  end

  def blocked?(%User{} = user, %User{} = target) do
    Block.exists?(user: user, target: target)
  end

  def relationship(%User{} = user, %User{} = target) do
    Relationship.get(user, target)
  end

  def with_relationship(
        %User{
          relationship: %Relationship{
            user_id: user_id
          }
        } = user,
        %User{
          id: user_id
        }
      ),
      do: user

  def with_relationship(%User{} = user, nil) do
    user
    |> Map.put(:relationship, nil)
  end

  def with_relationship(%User{} = user, %User{} = target) do
    user
    |> Map.put(:relationship, relationship(target, user))
  end

  def matched?(%User{} = user, %User{} = target) do
    LikesAndPasses.match_exists?(user: user, target: target)
  end

  def changeset(user, attrs, options \\ []) do
    user
    |> cast(attrs, [
      :language,
      :born_at
    ])
    |> validate_required(Keyword.get(options, :required, []))
    |> validate_inclusion(:language, Languages.list(:bcp_47),
      message: "is an unrecognized language"
    )
    |> validate_change(:born_at, fn _, born_at ->
      now = Date.utc_today()

      if Date.compare(born_at, Date.new!(now.year - 18, now.month, now.day)) === :gt do
        %{born_at: "must be at least 18 years old"}
      else
        %{}
      end
    end)
  end

  def get(id) when is_uid(id) do
    User |> where(id: ^id) |> preload(^default_assoc()) |> Repo.one()
  end

  def get(stripe_id: stripe_id) when is_binary(stripe_id) do
    User |> where(stripe_id: ^stripe_id) |> preload(^default_assoc()) |> Repo.one()
  end

  def get(_), do: nil

  def ilike_with_similarity(query, key, value) do
    query
    |> or_where([user], field(user, ^key) == ^value)
    |> or_where([user], ilike(field(user, ^key), ^"%#{value}%"))
    |> order_by([user], {:desc, fragment("similarity(?, ?)", field(user, ^key), ^value)})
  end

  defmodule Search do
    use Flirtual.EmbeddedSchema

    @optional [
      :search,
      :limit,
      :before,
      :after
    ]

    embedded_schema do
      field(:search, :string, default: "")

      # Pagination options.
      field(:limit, :integer, default: 10)
      field(:page, :integer, default: 1)
    end

    def changeset(value, _, _) do
      value
      |> validate_number(:limit, greater_than_or_equal_to: 1, less_than_or_equal_to: 100)
    end
  end

  def paginate(query, page, size) do
    query
    |> limit(^size)
    |> offset(^size * (^page - 1))
  end

  @default_search_fields [
    :email,
    :username,
    :stripe_id
  ]

  def search(attrs) do
    Repo.transaction(fn ->
      with {:ok, attrs} <- Search.apply(attrs) do
        value =
          attrs
          |> Map.get(:search, "")
          |> String.trim()

        entries =
          User
          |> preload(^default_assoc())
          |> then(
            &if(is_binary(value) and String.length(value) > 0,
              do:
                if(is_uid(value),
                  # if the value is a uid, search by id.
                  do: or_where(&1, id: ^value),
                  # loosely search by similarity.
                  else:
                    Enum.reduce(@default_search_fields, &1, fn field, query ->
                      ilike_with_similarity(query, field, value)
                    end)
                ),
              else: &1
            )
          )
          |> paginate(attrs.page, attrs.limit)
          |> Repo.all()

        %{
          entries: entries,
          metadata: %{
            page: attrs.page,
            limit: attrs.limit
          }
        }
      else
        {:error, reason} -> Repo.rollback(reason)
        reason -> Repo.rollback(reason)
      end
    end)
  end

  def search(_, _), do: []

  def suspend(
        %User{} = user,
        %Attribute{type: "ban-reason"} = reason,
        message,
        %User{} = moderator
      ) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    message = message || reason.metadata["details"]

    Repo.transaction(fn ->
      with {:ok, user} <-
             user
             |> change(%{banned_at: now})
             |> Repo.update(),
           {:ok, _} <- Report.list(target_id: user.id) |> Report.clear_all(moderator),
           {:ok, _} <- ChangeQueue.add(user.id),
           {_, _} <- Session.delete(user_id: user.id),
           User.Email.deliver(user, :suspended, message),
           :ok <-
             Discord.deliver_webhook(:suspended,
               user: user,
               moderator: moderator,
               reason: reason,
               message: message
             ) do
        user
      else
        {:error, reason} -> Repo.rollback(reason)
        reason -> Repo.rollback(reason)
      end
    end)
  end

  def unsuspend(%User{} = user, %User{} = moderator) do
    Repo.transaction(fn ->
      with {:ok, user} <-
             user
             |> change(%{banned_at: nil, shadowbanned_at: nil})
             |> Repo.update(),
           {:ok, _} <- ChangeQueue.add(user.id),
           :ok <-
             Discord.deliver_webhook(:unsuspended,
               user: user,
               moderator: moderator
             ) do
        user
      else
        {:error, reason} -> Repo.rollback(reason)
        reason -> Repo.rollback(reason)
      end
    end)
  end

  def warn(
        %User{} = user,
        message,
        %User{} = moderator
      ) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    Repo.transaction(fn ->
      with {:ok, user} <-
             user
             |> change(%{moderator_message: message})
             |> Repo.update(),
           :ok <-
             Discord.deliver_webhook(:warned,
               user: user,
               moderator: moderator,
               message: message,
               at: now
             ) do
        user
      else
        {:error, reason} -> Repo.rollback(reason)
        reason -> Repo.rollback(reason)
      end
    end)
  end

  def revoke_warn(
        %User{} = user,
        %User{} = moderator
      ) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    Repo.transaction(fn ->
      with {:ok, user} <-
             user
             |> change(%{moderator_message: nil})
             |> Repo.update(),
           :ok <-
             Discord.deliver_webhook(:warn_revoked,
               user: user,
               moderator: moderator,
               at: now
             ) do
        user
      else
        {:error, reason} -> Repo.rollback(reason)
        reason -> Repo.rollback(reason)
      end
    end)
  end

  def acknowledge_warn(%User{} = user) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    Repo.transaction(fn ->
      with {:ok, user} <-
             user
             |> change(%{moderator_message: nil})
             |> Repo.update(),
           :ok <-
             Discord.deliver_webhook(:warn_acknowledged,
               user: user,
               at: now
             ) do
        user
      else
        {:error, reason} -> Repo.rollback(reason)
        reason -> Repo.rollback(reason)
      end
    end)
  end

  def add_note(
        %User{} = user,
        message
      ) do
    Repo.transaction(fn ->
      with {:ok, user} <-
             user
             |> change(%{moderator_note: message})
             |> Repo.update() do
        user
      else
        {:error, reason} -> Repo.rollback(reason)
        reason -> Repo.rollback(reason)
      end
    end)
  end

  def remove_note(%User{} = user) do
    Repo.transaction(fn ->
      with {:ok, user} <-
             user
             |> change(%{moderator_note: nil})
             |> Repo.update() do
        user
      else
        {:error, reason} -> Repo.rollback(reason)
        reason -> Repo.rollback(reason)
      end
    end)
  end

  def validate_username(changeset) do
    changeset
    |> validate_required([:username])
    |> validate_format(:username, ~r/^[a-zA-Z0-9_]+$/,
      message: "must only contain letters, numbers, or underscores"
    )
    |> validate_length(:username, min: 3, max: 32)
  end

  def validate_unique_username(changeset) do
    changeset
    |> validate_username()
    |> unsafe_validate_unique(:username, Repo, query: from(User))
    |> unique_constraint(:username)
  end

  def validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end

  def validate_unique_email(changeset) do
    changeset
    |> validate_email()
    |> unsafe_validate_unique(:email, Repo, query: from(User))
    |> unique_constraint(:email)
  end

  def validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 72, count: :bytes)

    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
  end

  def validate_password_confirmation(changeset, options \\ []) do
    message = Keyword.get(options, :message, "Password doesn't match")
    changeset |> validate_confirmation(:password, message: message)
  end

  def put_password(%Changeset{} = changeset), do: put_password(changeset, :password)

  def put_password(%Changeset{} = changeset, field) when is_atom(field) do
    password = get_field(changeset, field)

    changeset
    |> put_password(password)
    |> delete_change(field)
  end

  def put_password(value, password) when is_binary(password) do
    change(value, %{password_hash: Bcrypt.hash_pwd_salt(password)})
  end

  def update_password(%User{} = user, password) do
    with {:ok, user} <-
           user
           |> put_password(password)
           |> Repo.update(),
         {_, _} <- Session.delete(user_id: user.id) do
      {:ok, user}
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def update_email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_unique_email()
    |> put_change(:email_confirmed_at, nil)
  end

  def confirm_email_changeset(user) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    user |> change(email_confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%User{password_hash: password_hash}, password) do
    valid_password?(password_hash, password)
  end

  def valid_password?(password_hash, password)
      when is_binary(password_hash) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, password_hash)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, user, options \\ []) do
    field = Keyword.get(options, :field, :current_password)

    if valid_password?(user, get_field(changeset, field)) do
      changeset
    else
      add_error(changeset, field, "Invalid password")
    end
  end
end

defimpl Elasticsearch.Document, for: Flirtual.User do
  alias Flirtual.Attribute
  import Flirtual.Utilities
  import Ecto.Query

  alias Flirtual.User.Profile.LikesAndPasses
  alias Flirtual.User
  alias Flirtual.Repo

  def id(%User{} = user), do: user.id
  def routing(_), do: false

  def encode(%User{} = user) do
    profile = user.profile

    attributes =
      profile.attributes
      |> Attribute.normalize_aliases()
      |> then(
        &if(user.preferences.nsfw,
          do: &1,
          else: exclude_by(&1, :type, "kink")
        )
      )
      |> Enum.map(& &1.id)
      |> Enum.sort()

    attributes_lf =
      profile.preferences.attributes
      |> then(
        &if(user.preferences.nsfw,
          do:
            &1 ++
              (profile.attributes
               |> filter_by(:type, "kink")
               |> Attribute.normalize_pairs()),
          else: exclude_by(&1, :type, "kink")
        )
      )
      |> Enum.map(& &1.id)
      |> Enum.sort()

    document =
      Map.merge(
        %{
          id: user.id,
          dob: user.born_at,
          active_at: user.active_at,
          agemin: profile.preferences.agemin || 18,
          agemax: profile.preferences.agemax || 128,
          openness: profile.openness,
          conscientiousness: profile.conscientiousness,
          agreeableness: profile.agreeableness,
          custom_interests:
            profile.custom_interests
            |> Enum.map(
              &(&1
                |> String.downcase()
                |> String.replace(~r/ |-/, "_"))
            ),
          attributes: attributes,
          attributes_lf: attributes_lf,
          country: profile.country,
          monopoly: profile.monopoly,
          serious: profile.serious,
          nsfw: user.preferences.nsfw,
          liked:
            LikesAndPasses
            |> where(profile_id: ^profile.user_id, type: :like)
            |> select([item], item.target_id)
            |> Repo.all()
        },
        if(user.preferences.nsfw,
          do: %{
            domsub: user.profile.domsub
          },
          else: %{}
        )
      )

    document
  end
end

defimpl Jason.Encoder, for: Flirtual.User do
  use Flirtual.Encoder,
    only: [
      :id,
      :email,
      :username,
      :language,
      :born_at,
      :moderator_message,
      :moderator_note,
      :talkjs_signature,
      :talkjs_id,
      :stripe_id,
      :banned_at,
      :shadowbanned_at,
      :email_confirmed_at,
      :deactivated_at,
      :active_at,
      :tags,
      :visible,
      :relationship,
      :matched,
      :blocked,
      :subscription,
      :preferences,
      :profile,
      :updated_at,
      :created_at
    ]
end

defimpl Swoosh.Email.Recipient, for: Flirtual.User do
  alias Flirtual.User

  def format(%User{} = user) do
    {User.display_name(user), user.email}
  end
end

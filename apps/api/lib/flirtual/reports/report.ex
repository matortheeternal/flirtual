defmodule Flirtual.Report do
  use Flirtual.Schema
  use Flirtual.Policy.Target, policy: Flirtual.Report.Policy

  require Flirtual.Utilities
  import Flirtual.Utilities

  import Flirtual.Attribute, only: [validate_attribute: 3]

  import Ecto.Changeset
  import Ecto.Query
  import Flirtual.Utilities.Changeset

  alias Flirtual.User.Profile.Block
  alias Flirtual.Discord
  alias Flirtual.{User, Attribute, Report, Repo}
  alias Flirtual.User.ChangeQueue

  schema "reports" do
    field(:message, :string, default: "")

    belongs_to(:user, User)
    belongs_to(:target, User)
    belongs_to(:reason, Attribute)

    field(:reviewed_at, :utc_datetime)

    timestamps(inserted_at: :created_at)
  end

  def default_assoc() do
    [:reason]
  end

  def changeset(%Report{} = report, attrs) do
    cast(report, attrs, [:user_id, :target_id, :reason_id, :message])
    |> validate_required(:user_id)
    |> validate_uid(:user_id)
    |> foreign_key_constraint(:user_id)
    |> validate_required(:target_id)
    |> validate_uid(:target_id)
    |> foreign_key_constraint(:target_id)
    |> then(
      &validate_change(&1, :target_id, fn _, target_id ->
        if(target_id === get_change(&1, :user_id),
          do: [target_id: "cannot report yourself"],
          else: []
        )
      end)
    )
    |> validate_required(:reason_id)
    |> validate_attribute(:reason_id, "report-reason")
    |> validate_length(:message, max: 256)
  end

  def create(attrs) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    Repo.transaction(fn ->
      with {:ok, report} <- %Report{} |> changeset(attrs) |> Repo.insert(),
           report <- Repo.preload(report, default_assoc()),
           %User{} = reporter <- User.get(report.user_id),
           %User{} = reported <- User.get(report.target_id),
           existing_unique_reports <-
             list_unresolved(target_id: reported.id)
             |> Enum.map(& &1.user_id)
             |> Enum.uniq(),
           {:ok, reported} <-
             if(length(existing_unique_reports) < 2,
               do: {:ok, reported},
               else:
                 reported
                 |> change(%{
                   shadowbanned_at: now
                 })
                 |> Repo.update()
             ),
           {_, _} <- Block.create(user: reporter, target: reported),
           {:ok, _} <- ChangeQueue.add(reported.id),
           :ok <-
             Discord.deliver_webhook(:report, %Report{report | user: reporter, target: reported}) do
        report
      else
        {:error, reason} -> Repo.rollback(reason)
        reason -> Repo.rollback(reason)
      end
    end)
  end

  def maybe_resolve_shadowban(target_id) when is_uid(target_id) do
    case list_unresolved(target_id: target_id) do
      [] ->
        # No unresolved reports.
        case User
             |> where([user], user.id == ^target_id and not is_nil(user.shadowbanned_at))
             |> Repo.one() do
          nil ->
            # User is not shadowbanned.
            {:ok, false}

          user ->
            # User is shadowbanned, resolve.
            {:ok, _} =
              user
              |> change(%{shadowbanned_at: nil})
              |> Repo.update()

            {:ok, true}
        end

      _ ->
        # User has unresolved reports, do nothing.
        {:ok, false}
    end
  end

  def clear(%Report{} = report, _) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    with {:ok, report} <-
           change(report, %{reviewed_at: now})
           |> Repo.update(),
         {:ok, _} <- maybe_resolve_shadowban(report.target_id) do
      {:ok, Repo.preload(report, default_assoc())}
    end
  end

  def clear_all(reports, moderator) do
    Repo.transaction(fn ->
      with {:ok, count} <-
             reports
             |> Enum.map(&clear(&1, moderator))
             |> then(
               &Enum.reduce(&1, {:ok, 0}, fn item, _ ->
                 case item do
                   {:error, _} -> item
                   {:ok, _} -> {:ok, length(&1)}
                 end
               end)
             ) do
        count
      else
        {:error, reason} -> Repo.rollback(reason)
        reason -> Repo.rollback(reason)
      end
    end)
  end

  def get(report_id) when is_uid(report_id) do
    Report |> where(id: ^report_id) |> Repo.one()
  end

  defmodule List do
    use Flirtual.EmbeddedSchema

    @optional [:reason_id, :target_id, :user_id]

    embedded_schema do
      field(:reason_id, :string)
      field(:target_id, :string)
      field(:user_id, :string)
      field(:reviewed, :boolean, default: false)
    end

    def changeset(value, _, _) do
      value
      |> validate_attribute(:reason_id, "report-reason")
      |> validate_uid(:target_id)
      |> validate_uid(:user_id)
      |> validate_queries(
        target_id: &where(User, id: ^&1),
        user_id: &where(User, id: ^&1)
      )
    end

    def validate_query(changeset, field, query) do
      validate_change(changeset, field, fn field, value ->
        if not Repo.exists?(query.(value)) do
          [{field, "does not exist"}]
        else
          []
        end
      end)
    end

    def validate_queries(changeset, queries) do
      Enum.reduce(queries, changeset, fn {field, query}, changeset ->
        validate_query(changeset, field, query)
      end)
    end
  end

  def list(target_id: target_id) when is_uid(target_id) do
    Report
    |> where(target_id: ^target_id)
    |> order_by(asc: :created_at)
    |> Repo.all()
  end

  def list(attrs) do
    with {:ok, attrs} <- List.apply(attrs) do
      include_reviewed = attrs[:reviewed] || false

      {:ok,
       from(report in Report,
         where: ^include_reviewed or is_nil(report.reviewed_at),
         order_by: [desc: report.created_at],
         join: reason in assoc(report, :reason),
         select_merge: %{
           reason: %{
             id: reason.id,
             name: reason.name
           }
         }
       )
       |> Repo.all()}
    end
  end

  def list_unresolved(target_id: target_id) when is_uid(target_id) do
    Report
    |> where([report], report.target_id == ^target_id and is_nil(report.reviewed_at))
    |> order_by(asc: :created_at)
    |> Repo.all()
  end
end

defimpl Jason.Encoder, for: Flirtual.Report do
  use Flirtual.Encoder,
    only: [
      :id,
      :user_id,
      :target_id,
      :reason,
      :message,
      :reviewed_at,
      :created_at
    ]
end

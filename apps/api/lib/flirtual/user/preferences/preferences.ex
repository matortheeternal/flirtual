defmodule Flirtual.User.Preferences do
  use Flirtual.Schema, primary_key: false
  use Flirtual.Policy.Target, policy: Flirtual.User.Preferences.Policy

  import Ecto.Changeset

  alias Flirtual.User
  alias Flirtual.User.Preferences
  alias Flirtual.User.Preferences.{EmailNotifications, Privacy}

  schema "preferences" do
    belongs_to :user, User, primary_key: true

    field :nsfw, :boolean, default: false
    field :theme, Ecto.Enum, values: [:light, :dark, :system], default: :light

    has_one :email_notifications, EmailNotifications,
      references: :user_id,
      foreign_key: :preferences_id

    has_one :privacy, Privacy, references: :user_id, foreign_key: :preferences_id
  end

  def default_assoc do
    [
      :email_notifications,
      :privacy
    ]
  end

  def update_changeset(%Preferences{} = preferences, attrs) do
    preferences
    |> cast(attrs, [
      :nsfw,
      :theme
    ])
  end
end

defimpl Jason.Encoder, for: Flirtual.User.Preferences do
  use Flirtual.Encoder,
    only: [
      :nsfw,
      :theme,
      :email_notifications,
      :privacy
    ]
end

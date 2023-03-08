defmodule Flirtual.User.Connection.Policy do
  use Flirtual.Policy

  alias Flirtual.User
  alias Flirtual.User.Connection

  # Any user can view the other user's connection if
  # their connections privacy setting is set to everyone.
  def authorize(:read, _, %Connection{
    user: %User{
      preferences: %User.Preferences{
        privacy: %User.Preferences.Privacy{
          connections: :everyone
        }
      }
    }
  }) do
    true
  end

  # The currently logged in user can view their own connections.
  def authorize(
        :read,
        %Plug.Conn{
          assigns: %{
            session: %{
              user_id: user_id
            }
          }
        },
        %Connection{
          user_id: user_id
        }
      ),
      do: true

  # Any other action, or credentials are disallowed.
  def authorize(_, _, _), do: false
end
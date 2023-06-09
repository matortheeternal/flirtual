defmodule FlirtualWeb.ImageController do
  use FlirtualWeb, :controller

  import FlirtualWeb.Utilities
  import Ecto.Changeset
  import Ecto.Query

  alias Flirtual.User.Profile.Image.Moderation
  alias Flirtual.Repo
  alias Flirtual.Policy
  alias Flirtual.User.Profile.Image

  action_fallback(FlirtualWeb.FallbackController)

  def get(conn, %{"image_id" => image_id}) do
    with %Image{} = image <- Image.get(image_id),
         :ok <- Policy.can(conn, :read, image) do
      conn |> json_with_etag(Policy.transform(conn, image))
    else
      nil -> {:error, {:not_found, "Image not found", %{image_id: image_id}}}
      value -> value
    end
  end

  @year_in_seconds 31_536_000

  def view(conn, %{"image_id" => image_id}) do
    with %Image{} = image <- Image.get(image_id),
         :ok <- Policy.can(conn, :view, image) do
      conn
      |> put_resp_header("cache-control", "public, max-age=#{@year_in_seconds}, immutable")
      |> put_resp_header("etag", image.external_id)
      |> put_status(:permanent_redirect)
      |> redirect(external: Image.url(image))
    else
      nil -> conn |> redirect(external: Image.url(nil))
      value -> value
    end
  end

  def delete(conn, %{"image_id" => image_id}) do
    with %Image{} = image <- Image.get(image_id),
         :ok <- Policy.can(conn, :delete, image),
         {:ok, _} <- Image.delete(image) do
      conn |> json(%{deleted: true})
    else
      nil -> {:error, {:not_found, "Image not found", %{image_id: image_id}}}
      value -> value
    end
  end

  def scan_queue(conn, _) do
    if String.match?(conn.assigns[:authorization_token_type], ~r/bearer/i) and
         conn.assigns[:authorization_token] !==
           Application.fetch_env!(:flirtual, :scan_queue_access_token) do
      {:error, {:unauthorized, "Invalid access token"}}
    else
      images = Moderation.list_scan_queue()

      conn
      |> json(%{
        hash: :crypto.hash(:sha, :erlang.term_to_binary(images)) |> Base.encode16(case: :lower),
        data: images
      })
    end
  end

  def resolve_scan_queue(conn, %{"data" => data}) do
    if String.match?(conn.assigns[:authorization_token_type], ~r/bearer/i) and
         conn.assigns[:authorization_token] !==
           Application.fetch_env!(:flirtual, :scan_queue_access_token) do
      {:error, {:unauthorized, "Invalid access token"}}
    else
      case Moderation.update_scan_queue(data) do
        {:ok, _} -> conn |> json(%{updated: true})
        _ -> {:error, {:unprocessable_entity, "Unable to update scan queue"}}
      end
    end
  end
end

defmodule FlirtualWeb.MatchmakingController do
  use FlirtualWeb, :controller

  def compute(conn, %{"id" => id}) do
    # Flirtual.Elasticsearch.dev_seed()
    conn |> json(Flirtual.Matchmaking.compute_potential_matches(id))
  end

  def update(conn, %{"id" => id}) do
    conn |> json(Flirtual.Matchmaking.patch_user(id, conn.body_params))
  end
end
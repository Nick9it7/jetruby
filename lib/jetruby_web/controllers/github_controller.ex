defmodule JetrubyWeb.GithubController do
  use JetrubyWeb, :controller

  alias Jetruby.Github

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, %{"name" => name}) do
    json(conn, Github.get_by(name: name))
  end

  def index(conn, %{"id" => repo_id}) do
    json(conn, Github.get_by(repo_id: repo_id))
  end

  def index(conn, _params) do
    json(conn, Github.all())
  end

  @spec sync(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def sync(conn, _params) do
    Github.Reminder.pull()
    json(conn, %{message: "synchronization started"})
  end
end

defmodule Jetruby.Github do
  @moduledoc """
  The Github context.
  """

  import Ecto.Query, warn: false
  alias Jetruby.Repo

  alias Jetruby.Github.Api
  alias Jetruby.Github.Repository

  @spec get_by(keyword()) :: any()
  def get_by(conditions) when is_list(conditions) do
    query =
      from r in Repository,
        where: ^conditions,
        order_by: r.stars

    Repo.one(query)
  end

  def get_by(_conditions), do: nil

  @spec all() :: any()
  def all() do
    Repository
    |> order_by([r], desc: r.stars)
    |> Repo.all()
  end

  @spec fetch() :: list(struct())
  def fetch do
    Api.fetch_all_repo()
    |> Enum.map(fn item ->
      %{
        repo_id: item["id"],
        name: item["full_name"],
        stars: item["stargazers_count"],
        data: item
      }
    end)
    |> create_repositories()
  end

  @spec create_repositories(list(map())) :: list(struct())
  def create_repositories(data) when is_list(data) do
    {_count, records} =
      Repository
      |> Repo.insert_all(
        data,
        returning: true,
        on_conflict: :replace_all,
        conflict_target: [:repo_id]
      )

    records
  end

  def create_repositories(_date), do: []
end

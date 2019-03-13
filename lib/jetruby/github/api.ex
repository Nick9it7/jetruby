defmodule Jetruby.Github.Api do

  @spec fetch_all_repo() :: list(map)
  def fetch_all_repo do
    with {:ok, %{body: body}} <-
           HTTPoison.get("https://github-trending-api.now.sh/repositories"),
         {:ok, body} <- Jason.decode(body) do
      Enum.flat_map(body, &search_repo(&1["author"] <> "/" <> &1["name"]))
    else
      _ -> []
    end
  end

  @spec search_repo(String.t()) :: list(map())
  def search_repo(query) do
    with {:ok, %{body: body}} <-
           HTTPoison.get(
             "https://api.github.com/search/repositories?q=#{query}&sort=stars&sort=desc"
           ),
         {:ok, body} <- Jason.decode(body) do
      body["items"] || []
    else
      _ -> []
    end
  end
end

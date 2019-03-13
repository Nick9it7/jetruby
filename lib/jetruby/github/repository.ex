defmodule Jetruby.Github.Repository do
  use Ecto.Schema

  @derive {Jason.Encoder, only: [:data]}
  schema "repositories" do
    field :data, :map
    field :name, :string
    field :repo_id, :integer
    field :stars, :integer
  end
end

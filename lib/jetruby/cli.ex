defmodule Jetruby.Cli do

  alias Jetruby.Github

  @commands [name: :string, id: :string, all: :boolean, sync: :boolean, help: :boolean]

  def main(args) do
    args |> parse_args |> do_process
  end

  def parse_args(args) do
    OptionParser.parse(args, strict: @commands)
    |> case do
      {[name: name], _, _} -> [name: name]
      {[id: id], _, _} -> [id: id]
      {[all: true], _, _} -> [all: true]
      {[sync: true], _, _} -> [sync: true]
      {[help: true], _, _} -> :help
      _ -> :help
    end
  end

  def do_process(name: name) do
    Github.get_by(name: name)
    |> Jason.encode_to_iodata!(pretty: true)
    |> IO.puts()
  end

  def do_process(id: id) do
    Github.get_by(repo_id: id)
    |> Jason.encode_to_iodata!(pretty: true)
    |> IO.puts()
  end

  def do_process(all: _) do
    Github.all()
    |> Jason.encode_to_iodata!(pretty: true)
    |> IO.puts()
  end

  def do_process(sync: _) do
    Github.Reminder.pull()

    %{message: "synchronization started"}
    |> Jason.encode_to_iodata!(pretty: true)
    |> IO.puts()
  end

  def do_process(:help) do
    IO.puts("""
      Usage:
      ./jetruby --name [repo name]
      ./jetruby --id [repo id]
      ./jetruby --all
      ./jetruby --sync

      Options:
      --help  Show this help message.
      --name  Show repositories by name.
      --id  Show repositories by id.
      --all  Show all repositories.
      --sync Pull trending repositories.

      Description:
      CLI client for Github API.
    """)

    System.halt(0)
  end
end

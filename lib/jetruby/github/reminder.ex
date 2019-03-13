defmodule Jetruby.Github.Reminder do
  use GenServer

  @timeout 100_000

  @spec init(any()) :: {:ok, any()}
  def init(_state), do: {:ok, %{timer: Process.send_after(__MODULE__, :pull, @timeout)}}

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def handle_info(:pull, %{timer: timer}) do
    Process.cancel_timer(timer)
    spawn_link(Jetruby.Github, :fetch, [])
    {:noreply, %{timer: Process.send_after(__MODULE__, :pull, @timeout)}}
  end

  @spec pull() :: any()
  def pull() do
    send(__MODULE__, :pull)
  end
end

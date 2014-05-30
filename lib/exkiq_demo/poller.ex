defmodule ExkiqDemo.Poller do
  use GenServer.Behaviour

  def start_link([redis_client]) do
    :gen_server.start_link(__MODULE__, [redis_client], [])
  end

  def init([redis_client]) do
    {:ok, redis_client, 0} # Use the timeout trick again.
  end

  def handle_info(:timeout, redis_client) do
    poll(redis_client)
  end

  def poll(redis_client) do
    IO.puts "Polling ..."
    result = redis_client 
             |> Exredis.query(["BRPOP", "queue:elixir", 0])
             |> ExkiqDemo.WorkerSupervisor.new_job
    :timer.sleep(1000)

    poll(redis_client)
  end

end

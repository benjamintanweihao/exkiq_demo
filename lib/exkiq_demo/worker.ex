defmodule ExkiqDemo.Worker do
  use GenServer.Behaviour

  def start_link(client) do
    :random.seed(:os.timestamp)
    :gen_server.start_link(__MODULE__, [client], [])
  end

  def init([client]) do
    {:ok, client}
  end

  def run(pid, job) do
    :gen_server.cast(pid, {:run, job})
  end

  def handle_cast({:run, job}, client) do
    IO.puts "Handling job ... #{job}"

    job         = JSON.decode!(job)
    jid         = job["jid"]
    args        = [jid, "Hello Hard Worker"] # TODO: Args should be the COMPUTED value
    queue       = "queue:default"            # Switch to the Rails default Sidekiq queue
    class       = "HardWorker"               # Change this to match Rails worker
    enqueued_at = job["enqueued_at"]

    new_job = HashDict.new 
              |> HashDict.put(:queue, queue)
              |> HashDict.put(:jid, jid)
              |> HashDict.put(:class, class)
              |> HashDict.put(:args, args)
              |> HashDict.put(:enqueued_at, enqueued_at)
              |> JSON.encode!

    client |> Exredis.query(["LPUSH", queue, new_job])

    {:noreply, client}
  end

end

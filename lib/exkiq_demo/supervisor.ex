defmodule ExkiqDemo.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    { :ok, client } = Exredis.start_link
    :supervisor.start_link(__MODULE__, [client])
  end

  def init(client) do
    children = [
      worker(ExkiqDemo.Poller, [client]),
      supervisor(ExkiqDemo.WorkerSupervisor, [client])
    ]

    supervise(children, strategy: :one_for_all)
  end
end

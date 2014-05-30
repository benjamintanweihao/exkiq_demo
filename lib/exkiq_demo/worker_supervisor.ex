defmodule ExkiqDemo.WorkerSupervisor do
  use Supervisor.Behaviour

  def start_link([client]) do
    :supervisor.start_link({:local, __MODULE__}, __MODULE__, [client])
  end

  def init([client]) do
    children = [
      worker(ExkiqDemo.Worker, [client])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def new_job(:undefined) do
    IO.puts "No job."
  end

  def new_job(job) do
    {:ok, pid} = :supervisor.start_child(__MODULE__, [])
    ExkiqDemo.Worker.run(pid, job)
  end

end

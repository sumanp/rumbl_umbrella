defmodule InfoSys.Counter do
  use GenServer

  def inc(pid), do: GenServer.cast(pid, :inc) #send asynchronous messages

  def dec(pid), do: GenServer.cast(pid, :dec) #send asynchronous messages

  def val(pid) do
    GenServer.call(pid, :val) #send synchronous messages that return the state of the server
  end

  def start_link(initial_val) do
    #start a GenServer, giving it the current module name and the counter
    GenServer.start_link(__MODULE__, initial_val)
    # This function spawns a new process and invokes the InfoSys.Counter.init function
    # inside this new process to set up its initial state.
  end

  def init(initial_val) do
    Process.send_after(self(), :tick, 1000)
    {:ok, initial_val}
  end

  def handle_cast(:inc, val) do
    {:noreply, val + 1}
  end

  def handle_cast(:dec, val) do
    {:noreply, val - 1}
  end

  def handle_call(:val, _from, val) do
    {:reply, val, val}
  end
  # Notice the _from in the function head. You can use an argument
  # leading with an underscore, just as you’d use a _ as wildcard match.
  # With this feature, we can explicitly describe the argument while ignoring the contents.
  def handle_info(:tick, val) when val <= 0, do: raise "boom!"
  
  def handle_info(:tick, val) do
    IO.puts("tick #{val}")
    Process.send_after(self(), :tick, 1000)
    {:noreply, val - 1}
  end
end

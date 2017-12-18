data = "input-18"
  |> File.read!
  |> String.trim
  |> String.split("\n")
  |> Enum.map(&String.split(&1, " "))

defmodule State do
  defstruct [
    id: 0,
    sent: 0,
    version: 1,
    master: nil,
    break: false,
    position: 0,
    registers: %{},
    instructions: [],
  ]
end

defmodule Day18 do
  def run(%{break: true, master: nil} = state), do: state
  def run(%{break: true} = state) do
    send state.master, {"ded", state.id, state}
    state
  end
  def run(%{position: pos, instructions: ins} = state)
  when pos < 0 or pos > length(ins) do
    run(%{state | break: true})
  end
  def run(state) when is_list(state) do
    run(%State{instructions: state})
  end
  def run(state) do
    [cmd | args] = Enum.at(state.instructions, state.position)
    state
      |> execute(cmd, args)
      |> Map.update!(:position, fn pos -> pos + 1 end)
      |> run
  end

  def value(_, key) when is_integer(key), do: key
  def value(state, key) do
    case Integer.parse(key) do
      {num, _} -> num
      :error -> Map.get(state.registers, key, 0)
    end
  end

  def execute(%{version: 2} = state, "snd", [x]) do
    x = value(state, x)
    send state.master, {"val", state.id, x}
    %{state | sent: state.sent + 1}
  end

  def execute(%{version: 2} = state, "rcv", [x]) do
    send state.master, {"gme", state.id, state}
    receive do
      value -> execute(state, "set", [x, value])
    end
  end

  def execute(state, "snd", [x]) do
    x = value(state, x)
    %{state | sent: x}
  end
  def execute(state, "rcv", [x]) do
    x = value(state, x)
    if x != 0 do
      %{state | break: true}
    else
      state
    end
  end

  def execute(state, "set", [x, y]) do
    y = value(state, y)
    registers = Map.put(state.registers, x, y)
    %{state | registers: registers}
  end
  def execute(state, "add", [x, y]) do
    y = value(state, y)
    registers = Map.update(state.registers, x, y, fn val -> val + y end)
    %{state | registers: registers}
  end
  def execute(state, "mul", [x, y]) do
    y = value(state, y)
    registers = Map.update(state.registers, x, 0, fn val -> val * y end)
    %{state | registers: registers}
  end
  def execute(state, "mod", [x, y]) do
    y = value(state, y)
    registers = Map.update(state.registers, x, 0, fn val -> rem(val, y) end)
    %{state | registers: registers}
  end
  def execute(state, "jgz", [x, y]) do
    x = value(state, x)
    y = value(state, y)
    if x > 0 do
      %{state | position: state.position + y - 1}
    else
      state
    end
  end

  def start(instructions) do
    base = %State{instructions: instructions, version: 2, master: self()}
    a = %{base | id: 0, registers: %{"p" => 0}}
    b = %{base | id: 1, registers: %{"p" => 1}}

    pid_a = spawn_link fn -> Day18.run(a) end
    pid_b = spawn_link fn -> Day18.run(b) end

    manage(%{0 => pid_a, 1 => pid_b}, %{0 => 0, 1 => 0}, %{0 => a, 1 => b})
  end

  def manage(relations, waiting, states) do
    receive do
      {"val", id, value} ->
        receiver = 1 - id
        pid = Map.get(relations, receiver)
        send pid, value
        waiting = Map.update!(waiting, receiver, fn x -> x - 1 end)
        manage(relations, waiting, states)
      {"gme", id, state} ->
        waiting = Map.update!(waiting, id, fn x -> x + 1 end)
        states = Map.put(states, id, state)
        die_or_manage(relations, waiting, states)
      {"ded", id, state} ->
        states = Map.put(states, id, state)
        die_or_manage(relations, waiting, states)
    end
  end

  def dead?(id, waiting, states) do
    broke = states |> Map.get(id, %{break: false}) |> Map.get(:break)
    needs_values = waiting |> Map.get(id)
    broke || (needs_values > 0)
  end

  def die_or_manage(relations, waiting, states) do
    if relations |> Map.keys |> Enum.all?(&dead?(&1, waiting, states)) do
      states
    else
      manage(relations, waiting, states)
    end
  end
end

IO.puts("Part 1: #{data |> Day18.run |> Map.get(:sent)}")
IO.puts("Part 2: #{data |> Day18.start |> Map.get(1) |> Map.get(:sent)}")

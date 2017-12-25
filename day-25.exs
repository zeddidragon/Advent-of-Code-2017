defmodule Machine do
  defstruct tape: %{}, pos: 0, state: "A", checksum_at: 0, step: 0, states: %{}

  def extract(regex, line) do
    regex
      |> Regex.run(line)
      |> List.last
  end

  def parse_line(machine, line, "Begin", _) do
    %{machine | state: ~r/in state (\S)/ |> extract(line)}
  end

  def parse_line(machine, line, "Perform", _) do
    %{machine | checksum_at: ~r/(\d+)/ |> extract(line) |> String.to_integer}
  end

  def parse_line(machine, line, "In", lines) do
    state = ~r/state (\S)/ |> extract(line)
    behaviour = parse_state(lines)
    {
      %{machine | states: Map.put(machine.states, state, behaviour)},
      lines |> Enum.drop_while(fn line -> !Regex.match?(~r/In state/, line) end)
    }
  end

  def parse_state(lines) do
    %{
      0 => lines |> Enum.slice(1..3) |> parse_substate,
      1 => lines |> Enum.slice(5..7) |> parse_substate,
    }
  end

  def parse_substate([write, move, continue]) do
    %{
      write: ~r/(\d+)/ |> extract(write) |> String.to_integer,
      dir: if Regex.match?(~r/right/, move) do 1 else -1 end,
      state: ~r/state (\S)/ |> extract(continue),
    }
  end

  def parse(lines, machine \\ %Machine{})
  def parse([], machine), do: machine
  def parse([line | lines], machine) do
    keyword = line
      |> String.split(" ", trim: true)
      |> hd
    case parse_line(machine, line, keyword, lines) do
      {machine, lines} -> parse(lines, machine)
      machine -> parse(lines, machine)
    end
  end

  def checksum(machine) do
    machine.tape
      |> Map.values
      |> Enum.reduce(0, &Kernel.+/2)
  end
end

data = "input-25"
  |> File.read!
  |> String.split("\n", trim: true)
  |> Machine.parse

defmodule Day25 do
  def run(machine, 0), do: machine
  def run(machine, steps) do
    value = Map.get(machine.tape, machine.pos, 0)
    behaviour = machine.states
      |> Map.get(machine.state)
      |> Map.get(value)
    machine = %{ machine |
      tape: Map.put(machine.tape, machine.pos, behaviour.write),
      pos: machine.pos + behaviour.dir,
      state: behaviour.state,
    }
    run(machine, steps - 1)
  end
end

IO.puts("Part 1: #{data |> Day25.run(data.checksum_at) |> Machine.checksum}")

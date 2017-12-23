defmodule Day23 do
  defstruct pos: 0, regs: %{}, mul: 0

  def maybe_parse(str) do
    case Integer.parse(str, 10) do
      {n, _} -> n
      :error -> str
    end
  end

  def parse_row(row) do
    row
      |> String.split(" ")
      |> Enum.map(&maybe_parse/1)
      |> List.to_tuple
  end

  def value(_, n) when is_integer(n), do: n
  def value(regs, n), do: Map.get(regs, n, 0)

  def exec(%{regs: regs} = state, {"set", x, y}) do
    %{state | regs: Map.put(regs, x, value(regs, y))}
  end
  
  def exec(%{regs: regs} = state, {"sub", x, y}) do
    y = value(regs, y)
    %{state | regs: Map.update(regs, x, -y, fn x -> x - y end)}
  end

  def exec(%{regs: regs, mul: mul} = state, {"mul", x, y}) do
    y = value(regs, y)
    %{state |
      mul: mul + 1,
      regs: Map.update(regs, x, 0, fn x -> x * y end),
    }
  end

  def exec(%{regs: regs, pos: pos} = state, {"jnz", x, y}) do
    if value(regs, x) == 0 do
      state
    else
      %{state | pos: pos + value(regs, y) - 1}
    end
  end

  def init(regs) do
    %Day23{regs: regs}
  end

  def run(cmds, state \\ %Day23{}) do
    # print(state)
    cmd = Map.get(cmds, state.pos)
    if cmd do
      state = exec(state, cmd)
      run(cmds, %{state | pos: state.pos + 1})
    else
      state
    end
  end

  # This will only work on my own input, most likely
  def shortcut do
    106500..123500
      |> Enum.take_every(17)
      |> Enum.count(fn b ->
        Enum.any?(2..div(b, 2), fn d ->
          rem(b, d) == 0
        end)
      end)
  end

  def print(%{regs: regs}) do
    str = "abcdefgh"
      |> String.split("", trim: true)
      |> Enum.map(fn char -> "#{char}: #{Map.get(regs, char, 0)}" end)
      |> Enum.map(&String.pad_trailing(&1, 12, " "))
      |> Enum.join(", ")
    IO.write("#{str} \r")
  end
end

data = "input-23"
  |> File.read!
  |> String.split("\n", trim: true)
  |> Enum.map(&Day23.parse_row/1)
  |> Enum.with_index
  |> Map.new(fn {row, i} -> {i, row} end)

IO.puts("Part 1: #{Day23.run(data).mul}")
IO.puts("Part 2: #{Day23.shortcut}")

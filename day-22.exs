defmodule Carrier do
  defstruct pos: {0, 0}, dir: {0, -1}, infected: 0, version: 0
end

defmodule Day22 do
  def draw(set, n, carrier) do
    coords = set |> Map.put_new(carrier.pos, ?.) |> Map.keys
    {left, right} = coords
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max
    {top, bottom} = coords
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max

    str = top..bottom
      |> Enum.map(fn y ->
        left..right
          |> Enum.map(fn x ->
            char = List.to_string([Map.get(set, {x, y}, ?.)])
            cond do
              carrier.pos == {x, y} -> "[#{char}"
              carrier.pos == {x - 1, y} -> "]#{char}"
              true -> " #{char}"
            end
          end)
          |> Enum.join("")
          |> String.replace(~r/^/, String.pad_leading("#{y}", 6))
      end)
      |> Enum.join("\n")

    IO.write("
#{IO.ANSI.clear}\e[0;0H
#{str}
Turn: #{n}
Infected: #{carrier.infected}
Pos: #{serialize(carrier.pos)}
Dir: #{serialize(carrier.dir)}
    ")
  IO.gets(">")
  end

  def serialize({x, y}) do
    "(#{x}, #{y})"
  end

  def parse_row({row, y}) do
    Enum.map(row, fn {char, x} -> {{x, y}, char} end)
  end

  def add({ax, ay}, {bx, by}) do
    {ax + bx, ay + by}
  end

  def move(carrier) do
    %{carrier | pos: add(carrier.pos, carrier.dir)}
  end
  
  def determine_state(state, 0) do
    case state do
      ?# -> ?.
      ?. -> ?#
    end
  end

  def determine_state(state, 1) do
    case state do
      ?# -> ?F
      ?F -> ?.
      ?. -> ?~
      ?~ -> ?#
    end
  end

  def turn({x, y}, state) do
    case state do
      ?# -> {-y, x}
      ?F -> {-x, -y}
      ?. -> {y, -x}
      ?~ -> {x, y}
    end
  end

  def burst(set, n, carrier \\ %Carrier{})
  def burst(set, n, carrier) when is_integer(carrier) do
    burst(set, n, %Carrier{version: carrier})
  end
  def burst(_, 0, carrier), do: carrier
  def burst(set, n, %{pos: pos, infected: count} = carrier) do
    # draw(set, n, carrier)
    state = Map.get(set, pos, ?.)
    dir = turn(carrier.dir, state)
    state = determine_state(state, carrier.version)
    set = Map.put(set, pos, state)
    count = if state == ?# do count + 1 else count end
    burst(set, n - 1, move(%{carrier | dir: dir, infected: count}))
  end
end

data = "input-22"
  |> File.read!
# data = "..#\n#..\n..."
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_charlist/1)

width = data |> hd |> length
height = data |> length

data = data
  |> Enum.map(&Enum.with_index(&1, div(width, -2)))
  |> Enum.with_index(div(height, -2))
  |> Enum.flat_map(&Day22.parse_row/1)
  |> Map.new

IO.puts("Part 1: #{Day22.burst(data, 10_000).infected}")
IO.puts("Part 2: #{Day22.burst(data, 10_000_000, 1).infected}")

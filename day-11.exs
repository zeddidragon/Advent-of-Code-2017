data = "input-11"
  |> File.read!
  |> String.trim
  |> String.split(",")

defmodule Day11 do
  def step({x, y}, dir) do
    case dir do
      "n"  -> {x, y - 1}
      "ne" -> {x + 1, y}
      "se" -> {x + 1, y + 1}
      "s"  -> {x, y + 1}
      "sw" -> {x - 1, y}
      "nw" -> {x - 1, y - 1}
    end
  end

  def distance({x, y}) when (abs(x) == x) == (abs(y) == y) do
    [x, y] |> Enum.max |> abs
  end
  def distance({x, y}) do
    abs(x) + abs(y)
  end
end

{pos, max} = Enum.reduce(data, {{0, 0}, 0}, fn dir, {pos, max} ->
  pos = Day11.step(pos, dir)
  distance = Day11.distance(pos)
  {pos, Enum.max([distance, max])}
end)
IO.puts("Part 1: #{Day11.distance(pos)}")
IO.puts("Part 2: #{max}")

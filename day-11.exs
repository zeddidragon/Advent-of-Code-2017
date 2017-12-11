data = "input-11"
  |> File.read!
  |> String.trim
  |> String.split(",")

defmodule Day11 do
  def step({x, y}, "n") do
    {x, y - 1}
  end
  def step({x, y}, "ne") do
    {x + 1, y}
  end
  def step({x, y}, "se") do
    {x + 1, y + 1}
  end
  def step({x, y}, "s") do
    {x, y + 1}
  end
  def step({x, y}, "sw") do
    {x - 1, y}
  end
  def step({x, y}, "nw") do
    {x - 1, y - 1}
  end

  def distance({x, y}) when x >= 0 and y >= 0 or x <= 0 and y <= 0 do
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

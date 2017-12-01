data = "input-01"
  |> File.read!
  |> String.trim
  |> String.split("")
  |> Enum.filter(fn(char) -> String.length(char) > 0 end)

defmodule Day1 do
  def shift(list, n) do
    Enum.slice(list, -n..-1) ++ Enum.slice(list, 0..-n)
  end

  def compare({a, b}) do
    if a == b do String.to_integer(a) else 0 end
  end

  def sum(list) do
    Enum.reduce(list, fn(a, b) -> a + b end)
  end
  
  def compute(a, b) do
    List.zip([a, b])
      |> Enum.map(&compare/1)
      |> sum
  end
end

part1_compared = Day1.shift(data, 1)
IO.puts("Part 1: #{Day1.compute(data, part1_compared)}")

part2_compared = Day1.shift(data, div(length(data),  2))
IO.puts("Part 2: #{Day1.compute(data, part2_compared)}")

defmodule Day19 do
  def parse_row({row, y}) do
    row
      |> Enum.map(fn {char, x} -> {{x, y}, char} end)
      |> Enum.filter(fn {_, char} -> char !== ?\s end)
  end

  def left({0, y}), do: {y, 0}
  def left({x, 0}), do: {0, -x}
  def right({0, y}), do: {-y, 0}
  def right({x, 0}), do: {0, x}

  def add({ax, ay}, {bx, by}) do
    {ax + bx, ay + by}
  end

  def visit(path, {pos, dir}) do
    if node = Map.get(path, pos) do
      {pos, dir, node}
    end
  end

  def move(path, pos, dir) do
    [
      {dir |> add(pos), dir},
      {dir |> left |> add(pos), left(dir)},
      {dir |> right |> add(pos), right(dir)},
    ] |> Enum.find_value(&visit(path, &1))
  end

  def follow(path, pos, dir, visited \\ []) do
    case move(path, pos, dir) do
      {pos, dir, node} ->
        follow(path, pos, dir, [node | visited])
      nil ->
        visited
    end
  end
end

data = "input-19"
  |> File.read!
  |> String.split("\n")
  |> Enum.map(&String.to_charlist/1)
  |> Enum.map(&Enum.with_index/1)
  |> Enum.with_index
  |> Enum.flat_map(&Day19.parse_row/1)
  |> Map.new

{x, 0} = data
  |> Map.keys
  |> Enum.find(fn {_, y} -> y == 0 end)
  |> IO.inspect

path = Day19.follow(data, {x, -1}, {0, 1})
letters = path
  |> Enum.filter(&Enum.member?(?A..?Z, &1))
  |> Enum.reverse
IO.puts("Part 1: #{letters}")
IO.puts("Part 2: #{length(path)}")
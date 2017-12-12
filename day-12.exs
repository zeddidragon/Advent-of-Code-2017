defmodule Day12 do
  def row_to_tuple(row) do
    [key | values] = row
      |> String.split(~r/ <-> |, /)
      |> Enum.map(&String.to_integer/1)
    {key, values}
  end

  def members(map, key, set \\ MapSet.new) do
    if MapSet.member?(set, key) do
      set
    else
      Enum.reduce(Map.get(map, key), MapSet.put(set, key), fn k, set ->
        MapSet.union(set, members(map, k, set))
      end)
    end
  end

  def groups(map, acc \\ [])
  def groups(map, acc) when map_size(map) == 0, do: acc
  def groups(map, acc) do
    group = members(map, map |> Map.keys |> hd)
    map
      |> Map.drop(group)
      |> groups([group | acc])
  end
end

data = "input-12"
  |> File.read!
  |> String.trim
  |> String.split("\n")
  |> Map.new(&Day12.row_to_tuple/1)

IO.puts("Part 1: #{data |> Day12.members(0) |> MapSet.size}")
IO.puts("Part 2: #{data |> Day12.groups |> length}")

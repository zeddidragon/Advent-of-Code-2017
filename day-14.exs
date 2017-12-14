require Day10
require Day12
IO.puts("=== Day 14 ===")

data = 'jxqlasbh'
seeds = 0..127
  |> Enum.map(&Integer.to_string/1)
  |> Enum.map(&String.to_charlist/1)
  |> Enum.map(fn code -> data ++ '-' ++ code end)
  |> Enum.map(&Day10.prepare_input/1)

defmodule Day14 do
  def knot_hash(sizes) do
    Enum.to_list(0..255)
      |> Day10.scramble(sizes)
      |> Day10.compress
  end

  def to_binary(hash) do
    hash
      # Integer to hex
      |> Enum.map(&Integer.to_string(&1, 16))
      |> Enum.map(&String.pad_leading(&1, 2, "0"))
      |> Enum.join("")
      # Individual hex digits to binary
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer(&1, 16))
      |> Enum.map(&Integer.to_string(&1, 2))
      |> Enum.map(&String.pad_leading(&1, 4, "0"))
      |> Enum.join("")
      # Individual binary digits to integers 1/0
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
  end

  def visualize(disk) do
    disk
      |> Enum.map(&Enum.join(&1, ""))
      |> Enum.join("\n")
      |> String.replace("1", "#")
      |> String.replace("0", ".")
      |> IO.puts

    disk
  end

  def neighbour_candidates(num, w) when rem(num, w) == 0, do: [-w, 1, w]
  def neighbour_candidates(num, w) when rem(num, w) == w - 1, do: [-w, -1, w]
  def neighbour_candidates(_, w), do: [-w, -1, 1, w]

  def neighbours(set, num, width) do
    num
      |> neighbour_candidates(width)
      |> Enum.map(fn offset -> num + offset end)
      |> Enum.filter(&MapSet.member?(set, &1))
  end

  def connections(disk) do
    width = disk |> hd |> length
    set = disk
      |> Enum.concat
      |> Enum.with_index(1)
      |> Enum.map(fn {v, i} -> v * i end)
      |> Enum.filter(fn n -> n > 0 end)
      |> Enum.map(fn n -> n - 1 end)
      |> MapSet.new

    Enum.reduce(set, %{}, fn num, map ->
      Map.put(map, num, neighbours(set, num, width))
    end)
  end
end


disk = seeds
  |> Enum.map(&Day14.knot_hash/1)
  |> Enum.map(&Day14.to_binary/1)

count = disk
  |> Enum.concat
  |> Enum.join("")
  |> String.split("", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Enum.count(fn num -> num == 1 end)

IO.puts("Part 1: #{count}")

groups = disk
  |> Day14.connections
  |> Day12.groups
  |> Enum.map(&MapSet.to_list/1)
  |> Enum.sort_by(&hd/1)
IO.puts("Part 2: #{groups |> length}")

require Bitwise
IO.puts("=== Day 10 ===")

data = "input-10"
  |> File.read!
  |> String.trim

list = Enum.to_list(0..255)

defmodule Day10 do
  def add_pepper(list) do
    list ++ [17, 31, 73, 47, 23]
  end

  def repeat(list, n) do
    Enum.reduce(1..n, [], fn _, acc -> acc ++ list end)
  end

  def prepare_input(list) do
    list |> add_pepper |> repeat(64)
  end

  def rotate(list, n) do
    {left, right} = Enum.split(list, n)
    right ++ left
  end

  def scramble(list, sizes, pos \\ 0, skip \\ 0)
  def scramble(list, [], pos, _) do
    rotate(list, length(list) - pos)
  end
  def scramble(list, [size | sizes], pos, skip) do
    len = length(list)
    shift = rem(size + skip, len)
    list
      |> Enum.reverse_slice(0, size)
      |> rotate(shift)
      |> scramble(sizes, rem(pos + shift, len), skip + 1)
  end

  def compress(list) do
    list
      |> Enum.chunk_every(16)
      |> Enum.map(fn chunk -> Enum.reduce(chunk, &Bitwise.bxor/2) end)
  end
end

part1_sizes = data
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)
[a, b | _] = Day10.scramble(list, part1_sizes)
IO.puts("Part 1: #{a * b}")

part2_sizes = data
  |> String.to_charlist
  |> Day10.prepare_input

hash = list
  |> Day10.scramble(part2_sizes)
  |> Day10.compress
  |> Enum.map(&Integer.to_string(&1, 16))
  |> Enum.map(&String.pad_leading(&1, 2, "0"))
  |> Enum.join("")
  |> String.downcase
IO.puts("Part 2: #{hash}")

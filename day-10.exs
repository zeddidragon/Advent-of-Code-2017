require Bitwise
require Regex

data = "input-10"
  |> File.read!
  |> String.replace(~r/\s/, "")
  |> String.trim

list = Enum.to_list(0..255)

defmodule Day10 do
  def rotate(list, pos) do
    {left, right} = Enum.split(list, pos)
    right ++ left
  end

  def knot_hash(list, sizes, pos \\ 0, skip \\ 0)
  def knot_hash(list, [], pos, _) do
    list
  end
  def knot_hash(list, [size | sizes], pos, skip) do
    len = length(list)
    
    new_pos = rem(pos + size + skip, len)
    if pos + size >= len do
      cut = pos + size - len
      {middle, right} = Enum.split(list, pos)
      {left, middle} = Enum.split(middle, cut)
      
      reversed = Enum.reverse(right ++ left)
      {right, left} = Enum.split(reversed, -cut)
      knot_hash(left ++ middle ++ right, sizes, new_pos, skip + 1)
    else
      knot_hash(Enum.reverse_slice(list, pos, size), sizes, new_pos, skip + 1)
    end
  end
end

as_numbers = data
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)
scrambled = Day10.knot_hash(list, as_numbers)
[first, second | _] = scrambled
IO.puts("Part 1: #{first * second}")

input = String.to_charlist(data)
input = []
input = input ++ [17, 31, 73, 47, 23]
input = Enum.reduce(1..64, [], fn _, acc -> acc ++ input end)
IO.inspect input
scrambled = Day10.knot_hash(list, input)
IO.inspect scrambled
hash = scrambled
  |> Enum.chunk_every(16)
  |> Enum.map(fn chunk -> Enum.reduce(chunk, &Bitwise.bxor/2) end)
  |> Enum.map(&Integer.to_string(&1, 16))
  |> Enum.map(&String.pad_leading(&1, 2, "0"))
  |> Enum.join("")
  |> String.downcase

IO.puts("Part 2: #{hash}")

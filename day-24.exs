data = "input-24"
  |> File.read!
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, "/"))
  |> Enum.map(fn list -> Enum.map(list, &String.to_integer/1) end)

defmodule Day24 do
  def strength(bridge) do
    Enum.reduce(bridge, 0, &Kernel.+/2)
  end

  def stronger?(a, b), do: strength(a) <= strength(b)
  def longer_or_stronger?(a, b) when length(a) == length(b), do: stronger?(a, b)
  def longer_or_stronger?(a, b), do: length(a) <= length(b)

  def build(pieces, bridge, sorter) do
    node = hd(bridge)
    pieces
      |> Enum.filter(&Enum.member?(&1, node))
      |> Enum.map(fn piece ->
        next = piece |> List.delete(node) |> hd
        pieces = List.delete(pieces, piece)
        build(pieces, [next, node], sorter)
      end)
      |> Enum.sort(sorter)
      |> List.last
      |> Kernel.||([])
      |> Enum.concat(bridge)
  end
end

strongest = data
  |> Day24.build([0], &Day24.stronger?/2)
  |> Day24.strength

IO.puts("Part 1: #{strongest}")

longest = data
  |> Day24.build([0], &Day24.longer_or_stronger?/2)
  |> Day24.strength

IO.puts("Part 2: #{longest}")

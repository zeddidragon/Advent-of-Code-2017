IO.puts("=== Day 16 ===")

defmodule Day16 do
  def row_to_tuple(row) do
    {
      row |> String.to_charlist |> hd,
      row |> String.slice(1..-1),
    }
  end

  def spin(list, n) do
    {left, right} = Enum.split(list, length(list) - n)
    right ++ left
  end

  def exchange(list, a_pos, b_pos) do
    a = Enum.at(list, a_pos)
    b = Enum.at(list, b_pos)
    list
      |> List.replace_at(a_pos, b)
      |> List.replace_at(b_pos, a)
  end

  def index_of(list, item) do
    Enum.find_index(list, fn i -> i == item end)
  end

  def partner(list, a, b) do
    a_pos = index_of(list, a)
    b_pos = index_of(list, b)
    list
      |> List.replace_at(a_pos, b)
      |> List.replace_at(b_pos, a)
  end

  def dance(list, []), do: list

  def dance(list, [{?s, args} | moves]) do
    list
      |> spin(String.to_integer(args))
      |> dance(moves)
  end

  def dance(list, [{?x, args} | moves]) do
    [a_pos, b_pos] = args
      |> String.split("/")
      |> Enum.map(&String.to_integer/1)
    list
      |> exchange(a_pos, b_pos)
      |> dance(moves)
  end

  def dance(list, [{?p, args} | moves]) do
    [a, b] = args
      |> String.split("/")
      |> Enum.join("")
      |> String.to_charlist
    list
      |> partner(a, b)
      |> dance(moves)
  end

  def perform(list, _, 0), do: list
  def perform(list, moves, count) do
    list
      |> dance(moves)
      |> perform(moves, count - 1)
  end

  def cycle_length(list, moves, count \\ 0, initial \\ nil)
  def cycle_length(list, _, count, initial) when list == initial, do: count
  def cycle_length(list, moves, count, initial) do
    list
      |> dance(moves)
      |> cycle_length(moves, count + 1, initial || list)
  end
end

data = "input-16"
  |> File.read!
  |> String.trim
  |> String.split(",")
  |> Enum.map(&Day16.row_to_tuple/1)

list = ?a..?p |> Enum.to_list

IO.puts("Part 1: #{Day16.dance(list, data)}")
cycle = Day16.cycle_length(list, data)
IO.puts("Part 2: #{Day16.perform(list, data, rem(1_000_000_000, cycle))}")

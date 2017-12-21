defmodule Day21 do
  use Bitwise

  def print(img) do
    img
      |> Enum.join("\n")
      |> IO.puts
    img
  end

  def flip_x(img) do
    img
      |> Enum.map(&Enum.reverse/1)
  end

  def flip_y(img) do
    img
      |> Enum.reverse
  end

  def rot_cw(img) do
    img
      |> Enum.reverse
      |> Enum.zip
      |> Enum.map(&Tuple.to_list/1)
  end

  def rot_ccw(img) do
    img
      |> Enum.zip
      |> Enum.reverse
      |> Enum.map(&Tuple.to_list/1)
  end

  def complete_key({key, value}) do
    [ [],
      [&flip_x/1],
      [&flip_y/1],
      [&rot_cw/1],
      [&rot_ccw/1],
      [&flip_x/1, &flip_y/1],
      [&flip_x/1, &rot_cw/1],
      [&flip_x/1, &rot_ccw/1],
    ]
      |> Enum.map(fn transforms ->
        Enum.reduce(transforms, key, fn transform, acc -> transform.(acc) end)
      end)
      |> Map.new(fn k -> {k, value} end)
  end

  def complete_map(map) do
    map
      |> Map.to_list
      |> Enum.map(&complete_key/1)
      |> Enum.reduce(&Map.merge/2)
  end

  def enchance(img, _, 0), do: img
  def enchance(img, rules, iter) do
    size = if (length(img) &&& 1) == 0 do 2 else 3 end
    img
      |> Enum.map(&Enum.chunk_every(&1, size))
      |> Enum.chunk_every(size)
      |> Enum.map(&Enum.zip/1)
      |> Enum.flat_map(fn row_chunk ->
        row_chunk
          |> Enum.map(&Tuple.to_list/1)
          |> Enum.map(&Map.get(rules, &1))
          |> Enum.zip
          |> Enum.map(&Tuple.to_list/1)
          |> Enum.map(&Enum.concat/1)
      end)
      |> enchance(rules, iter - 1)
  end

  def compute(img, rules, count) do
    img
      |> enchance(rules, count)
      |> Enum.concat
      |> Enum.count(&Kernel.==(&1, ?#))
  end
end

state = ['.#.', '..#', '###']

data = "input-21"
  |> File.read!
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, " => "))
  |> Enum.map(fn row ->
    row
      |> Enum.map(&String.split(&1, "/"))
      |> Enum.map(fn sub_row -> Enum.map(sub_row, &String.to_charlist/1) end)
  end)
  |> Map.new(&List.to_tuple/1)
  |> Day21.complete_map

IO.puts("Part 1: #{Day21.compute(state, data, 5)}")
IO.puts("Part 2: #{Day21.compute(state, data, 18)}")

state = ".#./..#/###"

data = "input-21"
  |> File.read!
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, " => "))
  |> Map.new(&List.to_tuple/1)

defmodule Day21 do
  use Bitwise

  def print(img) do
    img
      |> String.split("/")
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&Enum.intersperse(&1, " "))
      |> Enum.join("\n")
      |> IO.puts
    img
  end

  def flip_x(img) do
    img
      |> String.split("/")
      |> Enum.map(&String.reverse/1)
      |> Enum.join("/")
  end

  def flip_y(img) do
    img
      |> String.split("/")
      |> Enum.reverse
      |> Enum.join("/")
  end

  def rot_cw(img) do
    img
      |> String.split("/")
      |> Enum.reverse
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.zip
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.join(&1, ""))
      |> Enum.join("/")
  end

  def rot_ccw(img) do
    img
      |> String.split("/")
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.zip
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&Enum.join(&1, ""))
      |> Enum.join("/")
  end

  def enchance(img, _, 0), do: img
  def enchance(img, rules, iter) do
    size = ~r/.*\//
      |> Regex.run(img)
      |> hd
      |> String.length
      |> Kernel.-(1)
    size = if (size &&& 1) == 0 do 2 else 3 end
    img
      |> String.split("/")
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&Enum.chunk_every(&1, size))
      |> Enum.chunk_every(size)
      |> Enum.map(&Enum.zip/1)
      |> Enum.flat_map(fn row_chunk ->
        row_chunk
          |> Enum.map(&Tuple.to_list/1)
          |> Enum.map(&Enum.join(&1, "/"))
          |> Enum.map(&enchance_piece(&1, rules))
          |> Enum.map(&String.split(&1, "/"))
          |> Enum.zip
          |> Enum.map(&Tuple.to_list/1)
          |> Enum.map(&Enum.join(&1, ""))
      end)
      |> Enum.join("/")
      |> enchance(rules, iter - 1)
  end

  def enchance_piece(img, rules) do
    Map.get(rules, img) ||
    Map.get(rules, img |> flip_y) ||
    Map.get(rules, img |> flip_x) ||
    Map.get(rules, img |> rot_ccw) ||
    Map.get(rules, img |> rot_cw) ||
    Map.get(rules, img |> flip_y |> flip_x) ||
    Map.get(rules, img |> flip_x |> rot_ccw) ||
    Map.get(rules, img |> flip_x |> rot_cw)
  end

  def compute(img, rules, count) do
    img
      |> enchance(rules, count)
      |> String.replace(~r/\.|\//, "")
      |> String.length
  end
end

IO.puts("Part 1: #{Day21.compute(state, data, 5)}")
IO.puts("Part 2: #{Day21.compute(state, data, 18)}")

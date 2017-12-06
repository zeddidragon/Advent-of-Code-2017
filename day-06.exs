data = "input-06"
  |> File.read!
  |> String.trim
  |> String.split("\t")
  |> Enum.map(&String.to_integer/1)

defmodule Day6 do
  def print(blocks) do
    str = blocks
      |> Enum.map(&Integer.to_string/1)
      |> Enum.map(&String.pad_leading(&1, 2))
      |> Enum.join(" ")
    IO.write("#{str}")
  end

  def distribute(blocks, _, 0) do
    blocks
  end
  def distribute(blocks, index, count) do
    index = rem(index, length(blocks))
    blocks
      |> List.replace_at(index, Enum.at(blocks, index) + 1)
      |> distribute(index + 1, count - 1)
  end

  def reallocate(blocks) do
    max = Enum.max(blocks)
    index = Enum.find_index(blocks, fn v -> v == max end)
    blocks
      |> List.replace_at(index, 0)
      |> distribute(index + 1, max)
  end

  def find_repetition(blocks, history \\ [], count \\ 0) do
    print(blocks)
    IO.write("    | #{count}\r")

    if(Enum.member?(history, blocks)) do
      {blocks, count}
    else
      find_repetition(reallocate(blocks), [blocks | history], count + 1)
    end
  end
end

{repeated, count} = Day6.find_repetition(data)
IO.puts("\nPart 1: #{count}")
{_, cycle_size} = Day6.find_repetition(repeated)
IO.puts("\nPart 2: #{cycle_size}")

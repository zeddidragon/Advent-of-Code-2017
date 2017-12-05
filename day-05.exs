data = "input-05"
  |> File.read!
  |> String.trim
  |> String.split("\n")
  |> Enum.map(&String.to_integer/1)

defmodule Day5 do
  def jump(jumps, pos \\ 0, steps \\ 0) do
    value = Enum.at(jumps, pos)

    if value do
      jump(List.replace_at(jumps, pos, value + 1), pos + value, steps + 1)
    else
      steps
    end
  end

  def jump2(jumps, pos \\ 0, steps \\ 0) do
    value = Enum.at(jumps, pos)

    cond do
      value < 3 ->
        jump2(List.replace_at(jumps, pos, value + 1), pos + value, steps + 1)
      value -> 
        jump2(List.replace_at(jumps, pos, value - 1), pos + value, steps + 1)
      true ->
        steps
    end
  end
end

IO.puts("Computing part 1...")
IO.puts("Part 1: #{Day5.jump(data)}")
IO.puts("Computing part 2... (Grab a coffee, this will take a while)")
IO.puts("Part 2: #{Day5.jump2(data)}")

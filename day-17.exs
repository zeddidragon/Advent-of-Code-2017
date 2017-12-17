input = 303

defmodule Day17 do
  def spinlock(list, steps, total, current \\ 1, pos \\ 0)
  def spinlock(list, _, total, current, _) when total < current, do: list
  def spinlock(list, steps, total, current, pos) do
    pos = rem(pos + steps, current) + 1
    list
      |> List.insert_at(pos, current)
      |> spinlock(steps, total, current + 1, pos)
  end

  def shortspin(_, total, current, _, last_match) when total < current, do: last_match
  def shortspin(steps, total, current \\ 1, pos \\ 0, last_match \\ 0) do
    pos = rem(pos + steps, current)
    last_match =
      if pos == 0 do
        IO.write("Part 2: #{current}...\r")
        current
      else
        last_match
      end
    shortspin(steps, total, current + 1, pos + 1, last_match)
  end
end

slice = [0]
  |> Day17.spinlock(input, 2017)
  |> Enum.drop_while(fn i -> i !== 2017 end)
  |> Enum.take(2)

IO.puts("Part 1: #{slice |> Enum.join(",")}")
IO.puts("Part 2: #{Day17.shortspin(input, 50_000_000)} done!")

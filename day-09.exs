data = "input-09"
  |> File.read!
  |> String.trim
  |> String.to_charlist

defmodule Day9 do
  def wade_garbage(stream, count \\ 0)

  def wade_garbage([?!, _ | stream], count) do
    wade_garbage(stream, count)
  end

  def wade_garbage([?> | stream], count) do
    {stream, count}
  end

  def wade_garbage([_ | stream], count) do
    wade_garbage(stream, count + 1)
  end

  def compute_score(stream, total \\ 0, depth \\ 0, count \\ 0)

  def compute_score([?{ | stream], total, depth, count) do
    {stream, score, sub_count} = compute_score(stream, 0, depth + 1)
    compute_score(stream, total + score, depth, count + sub_count)
  end

  def compute_score([?< | stream], total, depth, count) do
    {stream, sub_count} = wade_garbage(stream)
    compute_score(stream, total, depth, count + sub_count)
  end

  def compute_score([?} | stream], total, depth, count) do
    {stream, total + depth, count}
  end

  def compute_score([?, | stream], total, depth, count) do
    compute_score(stream, total, depth, count)
  end

  def compute_score([], total, _, count) do
    {[], total, count}
  end
end

{_, score, count} = Day9.compute_score(data)
IO.puts("Part 1: #{score}")
IO.puts("Part 2: #{count}")

IO.puts("=== Day 15 ===")
# seeds = [65, 8921]  # Example seeds
seeds = [634, 301]  # Input seeds

defmodule Day15 do
  use Bitwise
  @factors [16807, 48271]
  @filter [4, 8]
  @divisor 2147483647 
  @mask 0b1111111111111111

  def generate({seed, factor, _}) do
    rem(seed * factor, @divisor)
  end

  def generate_picky({_, factor, filter} = tuple) do
    value = generate(tuple)
    if rem(value, filter) == 0 do
      value
    else
      generate_picky({value, factor, filter})
    end
  end

  def judge(seeds, iterations, generator, count \\ 0)
  def judge(_, 0, _, count), do: count
  def judge(seeds, i, generator, count) do
    [a, b] = [seeds, @factors, @filter]
      |> Enum.zip
      |> Enum.map(generator)

    count = if (a &&& @mask) == (b &&& @mask) do count + 1 else count end
    judge([a, b], i - 1, generator, count)
  end
end


IO.puts("Part 1: #{Day15.judge(seeds, 40_000_000, &Day15.generate/1)}")
IO.puts("Part 2: #{Day15.judge(seeds, 5_000_000, &Day15.generate_picky/1)}")

data = "input-02"
  |> File.read!
  |> String.trim
  |> String.split("\n")
  |> Enum.map(&String.split(&1, "\t"))
  |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)

defmodule Day2 do
  def sum(list) do
    Enum.reduce(list, fn(a, b) -> a + b end)
  end

  def minmaxdiff(row) do
    Enum.max(row) - Enum.min(row)
  end

  def division(_, nil) do end
  def division(a, b) do
    cond do
      rem(a, b) == 0 -> div(a, b)
      rem(b, a) == 0 -> div(b, a)
      true -> nil
    end
  end

  def evendiv([]) do
    0
  end
  def evendiv([_]) do
    0
  end
  def evendiv([first | list]) do
    value = Enum.find(list, &division(first, &1))
    division(first, value) || evendiv(list)
  end

  def checksum(table) do
    table
      |> Enum.map(&minmaxdiff/1)
      |> sum
  end

  def evendivsum(table) do
    table
      |> Enum.map(&evendiv/1)
      |> sum
  end
end

IO.puts("Part 1: #{Day2.checksum(data)}")
IO.puts("Part 2: #{Day2.evendivsum(data)}")

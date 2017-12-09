data = "input-08"
  |> File.read!
  |> String.trim
  |> String.split("\n")

defmodule Day8 do
  def test(condition, registers) do
    [register, comparator, value] = String.split(condition, " ")

    register_value = Map.get(registers, register, 0)
    value = String.to_integer(value)

    case comparator do
      "<" -> register_value < value
      ">" -> register_value > value
      "<=" -> register_value <= value
      ">=" -> register_value >= value
      "==" -> register_value == value
      "!=" -> register_value != value
    end
  end

  def perform(operation, registers) do
    [register, inc_dec, value] = String.split(operation, " ")
    value = String.to_integer(value)
    value = if inc_dec === "inc" do value else -value end
    
    value = Map.get(registers, register, 0) + value
    {Map.put(registers, register, value), value}
  end

  def compute([], registers, max) do
    {registers, max}
  end

  def compute([instruction | instructions], registers, max) do
    [operation, condition] = String.split(instruction, " if ")
    {registers, value} =
      if test(condition, registers) do
        perform(operation, registers)
      else
        {registers, max}
      end
    compute(instructions, registers, Enum.max([max, value]))
  end
end

{registers, max} = Day8.compute(data, %{}, 0)
IO.puts("Part 1: #{registers |> Map.values |> Enum.max}")
IO.puts("Part 2: #{max}")

defmodule Program do
  defstruct [
    name: '',
    weight: 0,
    total_weight: 0,
    parent: nil,
    children: [],
  ]

  def parse(row) do
    [name, weight | children] = String.split(row, " ")
    program = %Program{
      name: name,
      weight: (weight
        |> String.slice(1..-2)
        |> String.to_integer
      ),
      children: (children
        |> Enum.join(" ")
        |> String.replace("->", "")
        |> String.split(",")
        |> Enum.map(&String.trim/1)
        |> Enum.filter(fn str -> String.length(str) > 0 end)
      ),
    }
    program
  end
end

data = "input-07"
  |> File.read!
  |> String.trim
  |> String.split("\n")
  |> Enum.map(&Program.parse/1)

defmodule Day7 do
  def weight(program, mapped) do
    program.weight + (
      program.children
        |> Enum.map(&Map.get(mapped, &1))
        |> Enum.map(&weight(&1, mapped))
        |> Enum.reduce(0, fn a, b -> a + b end)
    )
  end

  def organize(programs) do
    mapped = Map.new(programs, fn p -> {p.name, p} end)

    with_parents = Enum.flat_map(programs, fn p ->
      Enum.map(p.children, fn child_name ->
        child = Map.get(mapped, child_name)
        %{child | parent: p.name, total_weight: weight(child, mapped)}
      end)
    end)
    
    remapped = Map.new(with_parents, fn p -> {p.name, p} end)
    orphan = Enum.find(programs, fn p -> !Map.has_key?(remapped, p.name) end)

    {orphan, remapped}
  end

  def find_imbalance(%{children: []} = program, _, expected) do
    {program, expected}
  end

  def find_imbalance(program, mapped, expected) do
    [_, second | _] = children = program.children
      |> Enum.map(fn name -> Map.get(mapped, name) end)
      |> Enum.sort_by(fn child -> child.total_weight end)
    faulty = children
      |> Enum.find(fn child -> child.total_weight != second.total_weight end)
    if faulty do
      find_imbalance(faulty, mapped, second.total_weight)
    else
      {program, expected}
    end
  end
end

{bottom, mapped} = Day7.organize(data)
IO.puts("Part 1: #{bottom.name}")

{faulty, expected} = Day7.find_imbalance(bottom, mapped, -1)
IO.puts("Part 2: #{expected - faulty.total_weight + faulty.weight}")

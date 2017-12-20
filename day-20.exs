IO.puts("=== Day 20 ===")

defmodule Particle do
  defstruct [:id, :pos, :vel, :acc]

  def parse_vector(str) do
    str
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
  end
  
  def parse({row, i}) do
    [pos, vel, acc] = ~r/(?:,?-?\d+){3}/
      |> Regex.scan(row)
      |> Enum.map(&hd/1)
      |> Enum.map(&parse_vector/1)
    %Particle{id: i, pos: pos, vel: vel, acc: acc}
  end

  def vector_length(vector) do
    vector
      |> Enum.map(&abs/1)
      |> Enum.reduce(&Kernel.+/2)
  end

  def vector_diff(a, b) do
    a
      |> Enum.zip(b)
      |> Enum.map(fn {a, b} -> a - b end)
  end

  def vector_sum(a, b) do
    [a, b]
      |> Enum.zip
      |> Enum.map(fn {a, b} -> a + b end)
  end

  def compare_attr(a, b, attr) do
    [a, b]
      |> Enum.map(&Map.get(&1, attr))
      |> Enum.map(&vector_length/1)
      |> Enum.reduce(&Kernel.-/2)
  end

  def next_attr(:acc), do: :vel
  def next_attr(:vel), do: :pos

  def compare(a, b, attr \\ :acc) do
    diff = compare_attr(a, b, attr)
    if diff == 0 do
      compare(a, b, next_attr(attr))
    else
      diff >= 0
    end
  end

  def move(particle) do
    vel = vector_sum(particle.vel, particle.acc)
    pos = vector_sum(particle.pos, vel)
    %{particle | pos: pos, vel: vel}
  end

  def simulate(particles, 0), do: particles
  def simulate(particles, step) do
    removed = particles
      |> Enum.group_by(&Map.get(&1, :pos))
      |> Map.values
      |> Enum.filter(fn group -> length(group) > 1 end)
      |> List.flatten
      |> MapSet.new
    particles
      |> Enum.reject(&MapSet.member?(removed, &1))
      |> Enum.map(&move/1)
      |> simulate(step - 1)
  end
end

data = "input-20"
  |> File.read!
  |> String.split("\n", trim: true)
  |> Enum.with_index
  |> Enum.map(&Particle.parse/1)

slowest = data
  |> Enum.sort(&Particle.compare/2)
  |> hd

IO.puts("Part 1: #{slowest.id}")

remaining = data
  |> Particle.simulate(100)
  |> Enum.sort_by(&Map.get(&1, :id))

IO.puts("Part 2: #{length(remaining)}")

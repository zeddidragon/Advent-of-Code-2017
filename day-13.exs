defmodule Scanner do
  defstruct depth: 0, range: 0, pos: 0, dir: 1
  def from_row(row) do
    [depth, range] = row
      |> String.split(": ")
      |> Enum.map(&String.to_integer/1)
    %Scanner{depth: depth, range: range}
  end

  def step(%{dir: -1, pos: 0} = unit) do
    step(%{unit | dir: 1})
  end
  def step(%{dir: 1, pos: pos, range: range} = unit) when pos == range - 1 do
    step(%{unit | dir: -1})
  end
  def step(%{pos: pos, dir: dir} = unit) do
    %{unit | pos: pos + dir}
  end

  def move(unit, 0), do: unit
  def move(unit, steps) do
    unit
      |> step
      |> move(steps - 1)
  end

  def severity(unit) do
    unit.depth * unit.range
  end
end

data = "input-13"
  |> File.read!
  |> String.trim
  |> String.split("\n")
  |> Enum.map(&Scanner.from_row/1)

defmodule Day13 do
  def step(scanners, depth \\ 0, severity \\ 0)
  def step([], _, severity), do: severity
  def step([scanner | scanners], depth, severity) do
    [scanner | scanners]
      |> Enum.map(&Scanner.move(&1, scanner.depth - depth))
      |> Day13.scan(severity)
  end

  def scan([%{pos: 0} = scanner | scanners], severity) do
    step(scanners, scanner.depth, Scanner.severity(scanner) + severity)
  end
  def scan([%{depth: depth} | scanners], severity) do
    step(scanners, depth, severity)
  end

  def safe_delay(scanners) do
    scanners
      |> Enum.map(fn unit -> Scanner.move(%{unit | dir: -1}, unit.depth + 1) end)
      |> safe_delay(1)
  end

  def safe_delay(scanners, delay) do
    IO.write("Part 2: #{delay}\r")
    if Enum.all?(scanners, fn unit -> unit.pos > 0 end) do
      delay
    else
      scanners
        |> Enum.map(&Scanner.step/1)
        |> safe_delay(delay + 1)
    end
  end
end

IO.puts("Part 1: #{data |> Day13.step}")
data |> Day13.safe_delay
IO.puts("\rDone!")

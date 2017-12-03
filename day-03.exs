input = 325489

defmodule Cursor do
  defstruct steps: 0, block: 1, rung: 0, dir: 'r', x: 0, y: 0
end

defmodule Day3 do
  def start(block) do
    move(%Cursor{steps: block - 1})
  end

  def step(cursor) do
    %{cursor | 
      steps: cursor.steps - 1,
      block: cursor.block + 1,
    }
  end

  def move(%{steps: 0} = cursor) do
    cursor
  end

  def move(cursor = %{dir: 'r'}) do
    if cursor.x > cursor.rung do
      move(%{cursor | dir: 'u', rung: cursor.rung + 1})
    else
      move(%{step(cursor) | x: cursor.x + 1})
    end
  end

  def move(cursor = %{dir: 'u'}) do
    if cursor.y == -cursor.rung do
      move(%{cursor | dir: 'l'})
    else
      move(%{step(cursor) | y: cursor.y - 1})
    end
  end

  def move(cursor = %{dir: 'l'}) do
    if cursor.x == -cursor.rung do
      move(%{cursor | dir: 'd'})
    else
      move(%{step(cursor) | x: cursor.x - 1})
    end
  end

  def move(cursor = %{dir: 'd'}) do
    if cursor.y == cursor.rung do
      move(%{cursor | dir: 'r'})
    else
      move(%{step(cursor) | y: cursor.y + 1})
    end
  end

  def distance(steps) do
    cursor = Day3.start(steps)
    abs(cursor.x) + abs(cursor.y)
  end

  def stresstest(value) do
    table = %{{0, 0} => 1}
    iterate(value, table, %Cursor{})
  end

  def sum(table, {x, y}) do
    Enum.reduce((y-1)..(y+1), 0, fn j, acc ->
      acc + Enum.reduce((x-1)..(x+1), 0, fn i, acc ->
        acc + Map.get(table, {i, j}, 0)
      end)
    end)
  end

  def iterate(value, table, cursor) do
    cursor = move(%{cursor | steps: 1})
    pos = {cursor.x, cursor.y}
    result = sum(table, pos)
    table = Map.put(table, pos, result)
    if result > value do
      result
    else
      iterate(value, table, cursor)
    end
  end
  
end
IO.puts("Part 1: #{Day3.distance(input)}")
IO.puts("Part 2: #{Day3.stresstest(input)}")

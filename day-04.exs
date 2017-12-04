data = "input-04"
  |> File.read!
  |> String.trim
  |> String.split("\n")
  |> Enum.map(&String.split(&1, " "))

defmodule Day4 do
  def valid?(phrase) do
    length(phrase) == (phrase |> Enum.uniq |> length)
  end

  def sort_word(word) do
    word
      |> String.split("")
      |> Enum.sort
  end

  def sort_words(phrase) do
    Enum.map(phrase, &sort_word/1)
  end
end

valid = data
  |> Enum.filter(&Day4.valid?/1)
IO.puts("Part 1: #{length(valid)}")

valid_sorted = data
  |> Enum.map(&Day4.sort_words/1)
  |> Enum.filter(&Day4.valid?/1)
IO.puts("Part 2: #{length(valid_sorted)}")

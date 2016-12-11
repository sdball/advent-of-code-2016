defmodule Day1.Instructions do
  def to_list(""), do: []
  def to_list(instructions) do
    instructions
    |> String.split(~r{[^0-9LR]}, trim: true)
    |> Enum.map(fn(instruction) -> parse(instruction) end)
    |> List.flatten
  end

  defp parse("L" <> text_number) do
    [:left, parse(text_number)]
  end

  defp parse("R" <> text_number) do
    [:right, parse(text_number)]
  end

  defp parse(text_number) do
    {integer, ""} = Integer.parse(text_number)
    integer
  end
end

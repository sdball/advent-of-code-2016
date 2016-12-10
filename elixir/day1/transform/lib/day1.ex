defmodule Day1 do
  def follow("") do
    0
  end

  def follow(instructions) do
    follow(starting_position, list_of(instructions))
  end

  def follow(position, []) do
    abs(position.x) + abs(position.y)
  end

  def follow(position, [:left | remaining]) do
    position
    |> turn_left
    |> follow(remaining)
  end

  def follow(position, [:right | remaining]) do
    position
    |> turn_right
    |> follow(remaining)
  end

  def follow(position, [blocks | remaining]) do
    position
    |> walk(blocks)
    |> follow(remaining)
  end

  def turn_left(position) do
    new_direction = case position.direction do
      :north -> :west
      :west  -> :south
      :south -> :east
      :east  -> :north
    end
    %{position | direction: new_direction }
  end

  def turn_right(position) do
    new_direction = case position.direction do
      :north -> :east
      :east  -> :south
      :south -> :west
      :west  -> :north
    end
    %{position | direction: new_direction }
  end

  def walk(position, blocks) do
    case position.direction do
      :north -> %{position | y: position.y + blocks}
      :east  -> %{position | x: position.x + blocks}
      :south -> %{position | y: position.y - blocks}
      :west  -> %{position | x: position.x - blocks}
    end
  end

  def list_of(""), do: []
  def list_of(instructions) do
    instructions
    |> String.split(~r{[^0-9LR]}, trim: true)
    |> Enum.map(fn(instruction) -> parse(instruction) end)
    |> List.flatten
  end

  def parse("L" <> number) do
    {number, _} = Integer.parse(number)
    [:left, number]
  end

  def parse("R" <> number) do
    {number, _} = Integer.parse(number)
    [:right, number]
  end

  def parse(instruction) do
    {integer, _} = Integer.parse(instruction)
    integer
  end

  def starting_position do
    %{direction: :north, x: 0, y: 0}
  end
end

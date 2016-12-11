defmodule Day1 do
  def count_blocks(file) do
    {:ok, pid} = Day1.Citywalk.start_link
    {:ok, distance} = Day1.Citywalk.follow(pid, instructions)
    IO.puts "After following all instructions we're #{distance} blocks from the start."
  end

  def first_intersection(file) do
    IO.inspect File.read!(file)
  end

  defp instructions do
    File.read!("../day1.txt")
    |> Day1.Instructions.to_list
  end
end

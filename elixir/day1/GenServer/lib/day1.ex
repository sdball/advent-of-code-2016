defmodule Day1 do
  def count_blocks do
    {:ok, pid} = Day1.Citywalk.start_link
    :ok = Day1.Citywalk.follow(pid, instructions)
    distance = Day1.Citywalk.distance_from_start(pid)
    IO.puts "After following all instructions we're #{distance} blocks from the start."
  end

  def first_intersection do
    instructions
  end

  defp instructions do
    File.read!("../day1.txt")
    |> Day1.Instructions.to_list
  end
end

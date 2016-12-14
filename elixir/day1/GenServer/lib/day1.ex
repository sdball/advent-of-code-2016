defmodule Day1 do
  def distance_from_start do
    {:ok, pid} = Day1.Citywalk.start_link
    :ok = Day1.Citywalk.follow(pid, instructions)
    distance = Day1.Citywalk.distance_from_start(pid)
    IO.puts "After following all instructions we're #{distance} blocks from the start."
  end

  def first_revisit do
    {:ok, pid} = Day1.Citywalk.start_link
    :ok = Day1.Citywalk.follow(pid, instructions)
    case Day1.Citywalk.find_first_revisit(pid) do
      :none ->
        IO.puts "While following instructions we revisited no point."
      point ->
        distance = Day1.Citywalk.distance_from_start(point)
        IO.puts "At the first revisited point we're #{distance} blocks from the start."
    end
  end

  defp instructions do
    File.read!("../day1.txt")
    |> Day1.Instructions.to_list
  end
end

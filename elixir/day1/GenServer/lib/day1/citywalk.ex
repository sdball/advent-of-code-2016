defmodule Day1.Citywalk do
  use GenServer

  defmodule State do
    defstruct x: 0, y: 0, direction: :north, visited_points: [[0,0]]
  end

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  # -- status

  def position(pid) do
    GenServer.call(pid, :position)
  end

  def direction(pid) do
    GenServer.call(pid, :direction)
  end

  def distance_from_start(pid) when is_pid pid do
    GenServer.call(pid, :distance_from_start)
  end

  def distance_from_start([x,y]) do
    abs(x) + abs(y)
  end

  def visited_points(pid) do
    GenServer.call(pid, :visited_points)
  end

  def find_first_revisit(pid) do
    visited_points(pid)
    |> find_first_revisit(MapSet.new)
  end

  def find_first_revisit([], _visited) do
    :none
  end

  def find_first_revisit([point | remaining], visited) do
    case MapSet.member?(visited, point) do
      true -> point
      false -> find_first_revisit(remaining, MapSet.put(visited, point))
    end
  end

  # -- commands

  def follow(_pid, []) do
    :ok
  end

  def follow(pid, [left_or_right | remaining]) when is_atom left_or_right do
    turn(pid, left_or_right)
    follow(pid, remaining)
  end

  def follow(pid, [blocks | remaining]) do
    walk(pid, blocks)
    follow(pid, remaining)
  end

  def turn(pid, direction) do
    GenServer.call(pid, {:turn, direction})
  end

  def walk(pid, 1) do
    GenServer.call(pid, {:walk, 1})
  end

  def walk(pid, blocks) do
    GenServer.call(pid, {:walk, 1})
    walk(pid, blocks - 1)
  end

  # -- GenServer callbacks

  def init([]) do
    {:ok, %State{}}
  end

  def handle_call(:position, _from, %{x: x, y: y} = state) do
    {:reply, [x,y], state}
  end

  def handle_call(:direction, _from, %{direction: direction} = state) do
    {:reply, direction, state}
  end

  def handle_call(:distance_from_start, _from, %{x: x, y: y} = state) do
    {:reply, distance_from_start([x,y]), state}
  end

  def handle_call(:visited_points, _from, %{visited_points: visited_points} = state) do
    {:reply, visited_points |> Enum.reverse, state}
  end


  def handle_call({:turn, :right}, _from, %{direction: direction} = state) do
    new_direction = case direction do
      :north -> :east
      :east  -> :south
      :south -> :west
      :west  -> :north
    end
    {:reply, [state.x, state.y], state |> update_state(new_direction)}
  end

  def handle_call({:turn, :left}, _from, %{direction: direction} = state) do
    new_direction = case direction do
      :north -> :west
      :west  -> :south
      :south -> :east
      :east  -> :north
    end
    {:reply, [state.x, state.y], state |> update_state(new_direction)}
  end

  def handle_call({:walk, blocks}, _from, %{x: x, y: y, direction: direction} = state) do
    [x,y] = case direction do
      :north -> [x, y + blocks]
      :east  -> [x + blocks, y]
      :south -> [x, y - blocks]
      :west  -> [x - blocks, y]
    end
    {:reply, [x,y], state |> update_state(x, y)}
  end

  defp update_state(state, new_direction) do
    state
    |> Map.put(:direction, new_direction)
  end

  defp update_state(%{visited_points: visited_points} = state, new_x, new_y) do
    state
    |> Map.put(:x, new_x)
    |> Map.put(:y, new_y)
    |> Map.put(:visited_points, [[new_x,new_y] | visited_points])
  end
end

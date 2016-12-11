defmodule Day1.Citywalk do
  use GenServer

  defmodule State do
    defstruct x: 0, y: 0, direction: :north
  end

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  # -- status

  def position(pid) do
    GenServer.call(pid, :position)
  end

  def distance_from_start(pid) do
    GenServer.call(pid, :distance_from_start)
  end

  def direction(pid) do
    GenServer.call(pid, :direction)
  end

  # -- commands

  def follow(pid, []) do
    {:ok, distance_from_start(pid)}
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

  def walk(pid, blocks) do
    GenServer.call(pid, {:walk, blocks})
  end

  # -- GenServer callbacks

  def init([]) do
    {:ok, %State{}}
  end

  def handle_call(:position, _from, %{x: x, y: y} = state) do
    {:reply, [x,y], state}
  end

  def handle_call(:distance_from_start, _from, %{x: x, y: y} = state) do
    {:reply, abs(x) + abs(y), state}
  end

  def handle_call(:direction, _from, %{direction: direction} = state) do
    {:reply, direction, state}
  end

  def handle_call({:turn, :right}, _from, %{direction: direction} = state) do
    new_direction = case direction do
      :north -> :east
      :east  -> :south
      :south -> :west
      :west  -> :north
    end
    {:reply, new_direction, %{state | direction: new_direction}}
  end

  def handle_call({:turn, :left}, _from, %{direction: direction} = state) do
    new_direction = case direction do
      :north -> :west
      :west  -> :south
      :south -> :east
      :east  -> :north
    end
    {:reply, new_direction, %{state | direction: new_direction}}
  end

  def handle_call({:walk, blocks}, _from, %{x: x, y: y, direction: direction} = state) do
    [x,y] = case direction do
      :north -> [x, y + blocks]
      :east  -> [x + blocks, y]
      :south -> [x, y - blocks]
      :west  -> [x - blocks, y]
    end
    {:reply, [x,y], %{state | x: x, y: y}}
  end
end

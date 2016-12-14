defmodule Day1.CitywalkTest do
  use ExUnit.Case
  alias Day1.Citywalk

  setup do
    {:ok, pid} = Citywalk.start_link
    {:ok, [pid: pid]}
  end

  test "starts at position 0,0", %{pid: pid} do
    assert Citywalk.position(pid) == [0,0]
  end

  test "starts at distance 0", %{pid: pid} do
    assert Citywalk.distance_from_start(pid) == 0
  end

  test "starts facing north", %{pid: pid} do
    assert Citywalk.direction(pid) == :north
  end

  test "can turn right", %{pid: pid} do
    assert Enum.map(1..4, fn(_) ->
      Citywalk.turn(pid, :right)
      Citywalk.direction(pid)
    end) == [ :east, :south, :west, :north ]
  end

  test "can turn left", %{pid: pid} do
    assert Enum.map(1..4, fn(_) ->
      Citywalk.turn(pid, :left)
      Citywalk.direction(pid)
    end) == [ :west, :south, :east, :north ]
  end

  test "can walk one block facing north", %{pid: pid} do
    assert Citywalk.direction(pid) == :north
    Citywalk.walk(pid, 1)
    assert Citywalk.position(pid) == [0,1]
  end

  test "can walk one block facing east", %{pid: pid} do
    Citywalk.turn(pid, :right)
    assert Citywalk.direction(pid) == :east
    Citywalk.walk(pid, 1)
    assert Citywalk.position(pid) == [1,0]
  end

  test "can walk one block facing south", %{pid: pid} do
    Citywalk.turn(pid, :right)
    Citywalk.turn(pid, :right)
    assert Citywalk.direction(pid) == :south
    Citywalk.walk(pid, 1)
    assert Citywalk.position(pid) == [0,-1]
  end

  test "can walk one block facing west", %{pid: pid} do
    Citywalk.turn(pid, :left)
    assert Citywalk.direction(pid) == :west
    Citywalk.walk(pid, 1)
    assert Citywalk.position(pid) == [-1,0]
  end

  describe "calculating the distance from the start" do
    test "can calculate distance from start going north", %{pid: pid} do
      assert Citywalk.direction(pid) == :north
      Citywalk.walk(pid, 5)
      assert Citywalk.distance_from_start(pid) == 5
    end

    test "can calculate distance from start going east", %{pid: pid} do
      Citywalk.turn(pid, :right)
      assert Citywalk.direction(pid) == :east
      Citywalk.walk(pid, 5)
      assert Citywalk.distance_from_start(pid) == 5
    end

    test "can calculate distance from start going south", %{pid: pid} do
      Citywalk.turn(pid, :right)
      Citywalk.turn(pid, :right)
      assert Citywalk.direction(pid) == :south
      Citywalk.walk(pid, 5)
      assert Citywalk.distance_from_start(pid) == 5
    end

    test "can calculate distance from start going west", %{pid: pid} do
      Citywalk.turn(pid, :left)
      assert Citywalk.direction(pid) == :west
      Citywalk.walk(pid, 5)
      assert Citywalk.distance_from_start(pid) == 5
    end

    test "can calculate a walk ending northeast", %{pid: pid} do
      Citywalk.turn(pid, :right)
      Citywalk.walk(pid, 5)
      Citywalk.turn(pid, :left)
      Citywalk.walk(pid, 5)
      Citywalk.turn(pid, :right)
      Citywalk.walk(pid, 5)
      Citywalk.turn(pid, :right)
      Citywalk.walk(pid, 3)
      assert Citywalk.distance_from_start(pid) == 12
    end

    test "can calculate a walk ending southwest", %{pid: pid} do
      Citywalk.turn(pid, :right)
      Citywalk.walk(pid, 2)
      Citywalk.turn(pid, :right)
      Citywalk.walk(pid, 2)
      Citywalk.turn(pid, :right)
      Citywalk.walk(pid, 3)
      assert Citywalk.distance_from_start(pid) == 3
    end
  end

  describe "following a list of instructions" do
    test "a list of no instructions returns :ok", %{pid: pid} do
      assert Citywalk.follow(pid, []) == :ok
    end

    test "follows instructions and returns :ok", %{pid: pid} do
      assert :ok == Citywalk.follow(pid, [:right, 5, :left, 2])
      assert 7 == Citywalk.distance_from_start(pid)
    end
  end

  describe "tracking points visited" do
    test "individual commands track points", %{pid: pid} do
      Citywalk.turn(pid, :right)
      assert Citywalk.visited_points(pid) == [[0,0]]

      Citywalk.walk(pid, 1)
      assert Citywalk.visited_points(pid) == [[0,0], [1,0]]

      Citywalk.turn(pid, :left)
      assert Citywalk.visited_points(pid) == [[0,0], [1,0]]

      Citywalk.walk(pid, 1)
      assert Citywalk.visited_points(pid) == [[0,0], [1,0], [1,1]]
    end

    test "following a list of instructions tracks visited points", %{pid: pid} do
      assert Citywalk.follow(pid, [:right, 5]) == :ok
      assert Citywalk.visited_points(pid) == [
        [0,0],
        [1,0],
        [2,0],
        [3,0],
        [4,0],
        [5,0],
      ]
    end

    test "complex instructions tracks visited points correctly", %{pid: pid} do
      assert Citywalk.follow(pid, [:right, 2, :right, 2, :right, 2, :right, 2])
      assert Citywalk.visited_points(pid) == [
        [0,0],
        [1,0],
        [2,0],
        [2,-1],
        [2,-2],
        [1,-2],
        [0,-2],
        [0,-1],
        [0,0],
      ]
    end
  end

  describe "finding first revisited point" do
    test "finds first revisited point", %{pid: pid} do
      assert Citywalk.follow(pid, [:right, 2, :right, 2, :right, 2, :right, 2])
      assert Citywalk.find_first_revisit(pid) == [0,0]
    end

    test "if no revisited points then :none", %{pid: pid} do
      assert Citywalk.follow(pid, [:right, 5])
      assert Citywalk.find_first_revisit(pid) == :none
    end
  end
end

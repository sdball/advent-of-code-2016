defmodule Day1Test do
  use ExUnit.Case

  describe "Day1.follow/1" do
    test "following no input is a distance of 0 blocks from the start" do
      assert Day1.follow("") == 0
    end

    test "following R2, L3 is a distance of 5 blocks from the start" do
      assert Day1.follow("R2, L3") == 5
    end

    test "following R2, R2, R2 is a distance of 2 blocks from the start" do
      assert Day1.follow("R2, R2, R2") == 2
    end

    test "following R5, L5, R5, R3 is a distance of 12 blocks from the start" do
      assert Day1.follow("R5, L5, R5, R3") == 12
    end

    test "following L24, R24 is a distance of 48 blocks from the start" do
      assert Day1.follow("L24, R24") == 48
    end
  end

  describe "Day1.list_of/1" do
    test "an empty string is an empty list of instructions" do
      assert Day1.list_of("") == []
    end

    test "a single instruction is broken down into turn and distance" do
      assert Day1.list_of("R5") == [:right, 5]
    end

    test "instructions with large distances are handled correctly" do
      assert Day1.list_of("R192") == [:right, 192]
    end

    test "a series of instructions is broken down into turns and distances" do
      assert Day1.list_of("R2, L3") == [:right, 2, :left, 3]
    end

    test "newlines in the instructions are ignored" do
      assert Day1.list_of("R2,\nL3") == [:right, 2, :left, 3]
    end
  end
end

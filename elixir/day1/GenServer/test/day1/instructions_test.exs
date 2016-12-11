defmodule Day1.InstructionsTest do
  use ExUnit.Case

  describe "Day1.Instructions.to_list/1" do
    test "an empty string is an empty list of instructions" do
      assert Day1.Instructions.to_list("") == []
    end

    test "a single instruction is broken down into turn and distance" do
      assert Day1.Instructions.to_list("R5") == [:right, 5]
    end

    test "instructions with large distances are handled correctly" do
      assert Day1.Instructions.to_list("R192, L48") == [:right, 192, :left, 48]
    end

    test "a series of instructions is broken down into turns and distances" do
      assert Day1.Instructions.to_list("R2, L3") == [:right, 2, :left, 3]
    end

    test "newlines in the instructions are ignored" do
      assert Day1.Instructions.to_list("R2,\nL3") == [:right, 2, :left, 3]
    end
  end
end

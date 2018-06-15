defmodule Chapter4QuestionsTest do
  use ExUnit.Case
  use ExUnitProperties

  property "lists:seq produces a list of a range between a number and a larger or equal number" do
    check all start <- integer(),
              count <- positive_integer() do
      list = :lists.seq(start, start + count)
      assert length(list) == count + 1
      assert increments(list)
    end
  end

  defp increments([h | t]), do: increments(h, t)
  defp increments(_, []), do: true
  defp increments(n, [h | t]) when h == n + 1, do: increments(h, t)
  defp increments(_, _), do: false
end

defmodule Chapter4QuestionsTest do
  use ExUnit.Case
  use ExUnitProperties

  property "lists:seq produces a list of a range between a number and a larger or equal number" do
    check all start <- integer(),
              finish <- integer() do
      case finish - start do
        -1 ->
          assert [] == :lists.seq(start, finish)

        n when n >= 0 ->
          list = :lists.seq(start, finish)
          assert length(list) == n + 1
          assert increments(list)

        _ ->
          # errors when finish - start < -1
          assert_raise(FunctionClauseError, fn -> :lists.seq(start, finish) end)
      end
    end
  end

  defp increments([h | t]), do: increments(h, t)
  defp increments(_, []), do: true
  defp increments(n, [h | t]) when h == n + 1, do: increments(h, t)
  defp increments(_, _), do: false
end

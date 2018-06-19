defmodule Chapter4QuestionsTest do
  use ExUnit.Case
  use ExUnitProperties

  property ":lists.seq/2 produces a list of a range between a number and a larger or equal number" do
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

  property ":lists.keysort/2 sorts tuples" do
    tuple_gen = tuple({integer(), string(:alphanumeric)})

    check all tuple_list <- list_of(tuple_gen),
              order_by_element <- integer(1..2) do
      sorted = :lists.keysort(order_by_element, tuple_list)

      assert ordered_by_key(order_by_element, sorted)

      assert length(tuple_list) == length(sorted)
    end
  end

  defp ordered_by_key(_n, []), do: true
  defp ordered_by_key(n, [h | t]), do: ordered_by_key(n, h, t)
  defp ordered_by_key(_n, _last, []), do: true

  defp ordered_by_key(n, last, [h | t]) do
    # elem is zero indexed, unlike :lists.keysort/2
    last_key = elem(last, n - 1)
    key = elem(h, n - 1)

    if last_key > key do
      false
    else
      ordered_by_key(n, h, t)
    end
  end
end

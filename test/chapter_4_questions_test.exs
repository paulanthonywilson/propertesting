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

  property "List.keysort/2 sorts tuples" do
    check all tuple_list <- list_of({integer(), string(:alphanumeric)}),
              order_by_element <- integer(0..1) do
      sorted = List.keysort(tuple_list, order_by_element)
      assert ordered_by_key(order_by_element, sorted)
      assert length(tuple_list) == length(sorted)
    end
  end

  defp ordered_by_key(_n, []), do: true
  defp ordered_by_key(n, [h | t]), do: ordered_by_key(n, h, t)
  defp ordered_by_key(_n, _last, []), do: true

  defp ordered_by_key(n, last, [h | t]) do
    last_key = elem(last, n)
    key = elem(h, n)

    if last_key > key do
      false
    else
      ordered_by_key(n, h, t)
    end
  end

  property "MapSet.union" do
    check all list_a <- list_of(integer()),
              list_b <- list_of(integer()) do
      set_a = MapSet.new(list_a)
      set_b = MapSet.new(list_b)

      model_union =
        list_a
        |> Enum.concat(list_b)
        |> Enum.sort()
        |> Enum.dedup()

      assert set_a
             |> MapSet.union(set_b)
             |> MapSet.to_list()
             |> Enum.sort() == model_union
    end
  end

  property "prop_dict_merge - too lax" do
    check all list_a <- list_of({simple_term(), simple_term()}),
              list_b <- list_of({simple_term(), simple_term()}) do
      merged =
        :dict.merge(fn _k, v1, _v2 -> v1 end, :dict.from_list(list_a), :dict.from_list(list_b))

      # right now occasionally fails due to 0 and 0.0 not being considered
      # equivalent as :dict keys, but being treated as equal by :lists.usort/1
      assert extract_keys(:lists.sort(:dict.to_list(merged))) ==
               :lists.usort(extract_keys(list_a ++ list_b))
    end
  end

  defp extract_keys(list) do
    for t <- list, do: elem(t, 0)
  end

  # term can make compound data types, which too slow for me
  defp simple_term() do
    one_of([integer(), binary(max_length: 8), float(), boolean()])
  end
end

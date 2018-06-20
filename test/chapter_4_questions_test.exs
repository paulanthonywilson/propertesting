defmodule Chapter4QuestionsTest do
  use ExUnit.Case
  use ExUnitProperties
  import PropTestSupport

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

  property "map.merge - made tighter" do
    check all map_a <- map_of(simple_term(), simple_term()),
              map_b <- map_of(simple_term(), simple_term()) do
      merged = Map.merge(map_a, map_b, fn _k, v1, _v2 -> v1 end)

      # Merged keys are a combination of keys from both maps
      assert merged
             |> Map.keys()
             |> Enum.sort() ==
               map_a
               |> Map.keys()
               |> Enum.concat(Map.keys(map_b))
               |> Enum.sort()
               # sort of pointless as the chances of a key collision are quite low
               |> Enum.dedup()

      assert sorted_and_unique(Map.keys(merged)) ==
               sorted_and_unique(Map.keys(map_a) ++ Map.keys(map_b))

      {merge_kv_from_map_a, merge_kv_from_map_b} =
        Enum.split_with(merged, fn {k, _v} -> Map.has_key?(map_a, k) end)

      # All the values in Map 1 are present in the merged, as per the conflict resolution function
      # provided Map.merge/3
      assert element_counts(merge_kv_from_map_a) == element_counts(map_a)

      map_b_value_set =
        map_b
        |> Map.values()
        |> MapSet.new()

      set_of_merged_values_from_map_b =
        merge_kv_from_map_b
        |> Enum.map(fn {_k, v} -> v end)
        |> MapSet.new()

      # All the values from keys not in map_a are from map_b - no conflict resolution applied
      assert MapSet.subset?(set_of_merged_values_from_map_b, map_b_value_set)
    end
  end

  # term can make compound data types, which too slow for me
  defp simple_term() do
    one_of([integer(), binary(max_length: 8), float(), boolean()])
  end
end

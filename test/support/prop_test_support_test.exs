defmodule PropTestSupportTest do
  use ExUnit.Case, async: true
  import PropTestSupport
  doctest PropTestSupport

  test "element_count" do
    assert element_counts([]) == %{}
    assert element_counts([1, 2, 1, 3]) == %{1 => 2, 2 => 1, 3 => 1}
    assert element_counts(MapSet.new([:a, :b])) == %{a: 1, b: 1}
    assert element_counts(%{a: 1, b: 2}) == %{{:a, 1} => 1, {:b, 2} => 1}
  end
end

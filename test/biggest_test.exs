defmodule BiggestTest do
  use ExUnit.Case
  use ExUnitProperties

  import Biggest

  test "example tests do" do
    assert 5 == biggest([1, 2, 3, 4, 5])
    assert 8 == biggest([3, 8, 7, -1])
    assert -5 == biggest([-10, -5, -901])
    assert 0 == biggest([0])
  end

  property "biggest is the first item in a desceding sorted list of integers" do
    check all l <- list_of_integers() do
      assert List.last(Enum.sort(l)) == biggest(l)
    end
  end

  defp list_of_integers() do
    int_gen = StreamData.integer()
    StreamData.list_of(int_gen)
  end
end

defmodule PropTestSupport do
  @doc """
  Counts the number of elements in an enumerable
  eg
  iex>element_counts([:a, :b, :a, :c])
  %{a: 2, b: 1, c: 1}
  """
  @spec element_counts(Enum.t()) :: Map.t()
  def element_counts(enum) do
    enum
    |> Enum.group_by(& &1)
    |> Enum.map(fn {k, v} -> {k, length(v)} end)
    |> Enum.into(%{})
  end

  @doc """
  Takes the enum and returns a sorted and unique list
  eg
  iex>sorted_and_unique([5, 7, 3, 7])
  [3, 5, 7]
  """
  def sorted_and_unique(enum) do
    enum
    |> Enum.sort()
    |> Enum.dedup()
  end
end

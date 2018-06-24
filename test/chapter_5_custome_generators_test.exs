defmodule Chapter5CustomGeneratorsTest do
  @moduledoc """
  This chapter is very PropEr specific, which is fair enough.

  Limiting generated strings fell out naturally in WordCountTest / chapter 4.

  This chapter implies that some combinations (eg "") won't be likely to be
  generated by PropEr in the default 100 iterations; StreamData does, as it
  favours with smaller sized values first: empty strings, arrays, etc...

  The reporters for data distribution don't seem to be in StreamData.

  There's nothing like `collect/1` and `aggregate/1` in StreamData ...
  """
  use ExUnit.Case
  use ExUnitProperties
  import PropTestSupport

  setup context do
    %{test: test_name} = context
    # Only for a single property as a proof of concept.
    {:ok, stat_collector} = Agent.start(fn -> [] end)

    collect = fn value ->
      Agent.update(stat_collector, fn values -> [value | values] end)
    end

    on_exit(fn ->
      IO.puts("")
      IO.puts(test_name)
      IO.puts("------------")

      stat_collector
      |> Agent.get(fn values -> element_counts(values) end)
      |> Enum.sort_by(fn {_value, count} -> count end)
      |> Enum.map(fn {value, count} -> IO.puts("#{count}:\t#{inspect(value)}") end)

      Agent.stop(stat_collector)
    end)

    {:ok, collector: collect}
  end

  property "mimics PropEr's `collect` as a proof of concept", context do
    %{collector: collect} = context

    check all bin <- binary() do
      collect.(to_range(10, byte_size(bin)))
    end
  end

  property "collect with resize", context do
    %{collector: collect} = context

    check all bin <- resize(binary(), 150) do
      collect.(to_range(25, byte_size(bin)))
    end
  end

  defp to_range(m, n) do
    base = div(n, m)
    {base * m, (base + 1) * m}
  end
end

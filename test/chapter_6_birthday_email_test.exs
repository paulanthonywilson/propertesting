defmodule Chapter6BirthdayEmailTest do
  @moduledoc """
  Stateless example  - chapter 6

  """

  use ExUnit.Case
  use ExUnitProperties
  import PropTestSupport

  property "blah" do
    check all(
            s <- csv_source(),
            max_runs: 20
          ) do
      IO.inspect(s)
    end
  end

  defp csv_source do
    bind(positive_integer(), fn size ->
      bind(header(size), fn keys ->
        list_of(entry(size, keys))
      end)
    end)
  end

  defp entry(size, keys) do
    size
    |> record()
    |> bind(fn vals ->
      keys
      |> Enum.zip(vals)
      |> Enum.into(%{})
      |> constant()
    end)
  end

  @textdata String.to_charlist(
              "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789" <>
                ":;<=>?@ !#$%&'()*+-./[\\]^_`{|}~"
            )

  defp header(size), do: list_of(name(), length: size)

  defp record(size), do: list_of(name(), length: size)

  defp name(), do: field()

  defp field, do: one_of([quotable_text(), unquoted_text()])

  defp quotable_text(), do: string('\r\n",' ++ @textdata)

  defp unquoted_text(), do: string(@textdata)
end

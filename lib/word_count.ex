defmodule WordCount do
  @moduledoc """
  For PropEr testing Chapter 4, Q7.
  """

  @doc """
  Count the words in the strings. Only have to consider spaces to be word
  separators in this weird case.
  """
  @spec count(String.t()) :: non_neg_integer()
  def count(string) do
    string
    |> String.split(~r/[ ]+/, trim: true)
    |> length()
  end
end

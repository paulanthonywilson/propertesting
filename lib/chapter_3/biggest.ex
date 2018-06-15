defmodule Biggest do
  def biggest([]), do: nil

  def biggest(list) do
    Enum.reduce(list, fn
      lhs, rhs when lhs > rhs -> lhs
      _lhs, rhs -> rhs
    end)
  end
end

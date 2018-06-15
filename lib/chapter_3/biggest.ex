defmodule Biggest do
  def biggest([]), do: nil

  def biggest([h | t]) do
    biggest(t, h)
  end

  def biggest([], biggest), do: biggest
  def biggest([h | t], biggest) when h > biggest, do: biggest(t, h)
  def biggest([_ | t], biggest), do: biggest(t, biggest)
end

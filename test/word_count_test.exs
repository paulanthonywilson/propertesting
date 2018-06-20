defmodule WordCountTest do
  use ExUnit.Case
  use ExUnitProperties

  property "counting words" do
    # Chapter 4, Q7 answer. In this case explicitly including whitespace
    # as only space is considered a delimiter. Rather than doing an alternative
    # implementation I generated a list of words and made that into a string, separated
    # by multiple instances of spaces

    check all words_with_tabs_and_newlines <-
                list_of(string([?a..?z, ?A..?Z, ?\t, ?\n], min_length: 1)),
              separator <- string(?\s..?\s, min_length: 1) do
      string_with_words = Enum.join(words_with_tabs_and_newlines, separator)

      assert length(words_with_tabs_and_newlines) == WordCount.count(string_with_words)
    end
  end
end

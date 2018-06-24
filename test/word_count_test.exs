defmodule WordCountTest do
  use ExUnit.Case
  use ExUnitProperties

  property "counting words" do
    # Chapter 4, Q7 answer. In this case explicitly including whitespace
    # as only space is considered a delimiter. Rather than doing an alternative
    # implementation I generated a list of words and made that into a string, separated
    # by multiple instances of spaces

    check all words_with_tabs_and_newlines <- word_list_including_non_space_whitespace_chars(),
              separator <- strings_with_only_spaces() do
      string_with_words = Enum.join(words_with_tabs_and_newlines, separator)
      assert length(words_with_tabs_and_newlines) == WordCount.count(string_with_words)
    end
  end

  defp word_list_including_non_space_whitespace_chars() do
    list_of(string([?a..?z, ?A..?Z, ?\t, ?\n], min_length: 1))
  end

  defp strings_with_only_spaces() do
    string(?\s..?\s, min_length: 1)
  end
end

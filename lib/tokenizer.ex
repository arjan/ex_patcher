#
# Tokenizer
#
# Input 1: {text}
# Input 2: {current}
# Input 3: {fun}
# Output 1: state
#   :normal
#   :whitespace
#
defmodule Tokenizer do
  def tokenize(text) do
    base_tokenize(text |> String.to_charlist(), :normal, [], &Tokenizer.parse_token/1, [])
  end

  def parse_token(current) do
    IO.write('<' ++ current ++ '>')
  end

  def base_tokenize([], _state, _current, _fun, _result) do
  end

  def base_tokenize([head | tail], state, current, fun, result) do
    {state, current, result} = parse_char(head, result, state, current, fun)
    base_tokenize(tail, state, current, fun, result)
  end

  #
  # state: whitespace
  #
  @whitespace [10, 32]

  def parse_char(char, _result, :whitespace, current, _fun) when char in @whitespace do
    {:whitespace, current ++ [char], current}
  end

  def parse_char(head, _result, :whitespace, current, fun) do
    {:normal, [head], fun.(current)}
  end

  #
  # state: normal
  #

  def parse_char(char, _result, state, current, fun) when char in @whitespace do
    {:whitespace, [char], fun.(current)}
  end

  def parse_char(head, _result, state, current, _fun) do
    {:normal, current ++ [head], current}
  end
end

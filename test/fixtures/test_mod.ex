defmodule Fixtures.TestMod do
  @moduledoc """
  Does someting
  """
  def foo do
    IO.puts(IO.char_data_to_string(["Hello", ", world!"]))
  end

  def bar do
    IO.puts(IO.char_data_to_string(["Hello", ", world!"]))
  end
end

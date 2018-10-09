defmodule ExPatcherTest do
  use ExUnit.Case
  doctest ExPatcher

  test "greets the world" do
    source = ExPatcher.read("test/fixtures/test_mod.ex")

    a =
      source
      |> ExPatcher.to_string()
      |> String.split("\n")

    b =
      source
      |> ExPatcher.patch_io_chardata_to_string()
      |> ExPatcher.to_string()
      |> String.split("\n")

    # List.myers_difference(a, b)
    # |> IO.inspect(label: "diff")
  end
end

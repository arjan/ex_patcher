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

    source_str = elem(source, 0)

    List.myers_difference(a, b)
    |> Enum.reduce(
      {nil, source_str},
      fn
        {:ins, ins}, {{:del, del}, source_str} ->
          source_str =
            Enum.zip(del, ins)
            |> Enum.reduce(source_str, fn {d, i}, s ->
              String.replace(s, d, i)
            end)

          {{:del, del}, source_str}

        a, {_pref, source_str} ->
          {a, source_str}
      end
    )
    |> elem(1)
    |> IO.puts()
  end
end

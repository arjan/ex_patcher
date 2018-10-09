defmodule ExPatcher do
  def read(file) do
    contents = File.read!(file)
    {:ok, ast} = Code.string_to_quoted(contents)
    {contents, ast}
  end

  def patch_io_chardata_to_string({file, ast}) do
    ast = Macro.postwalk(ast, &fix_it/1)
    {file, ast}
  end

  defp fix_it({:., meta, [{:__aliases__, b, [:IO]}, :char_data_to_string]}) do
    {:., meta, [{:__aliases__, b, [:IO]}, :chardata_to_string]}
  end

  defp fix_it({:greet, meta, [a, b]}) do
    {:greet, meta, [b, a]}
  end

  defp fix_it({{:., a, [{:__aliases__, b, [:Enum]}, :filter_map]}, c, [filter, mapper]}) do
    quote do
      Enum.filter(unquote(filter))
      |> Enum.map(unquote(mapper))
    end
  end

  defp fix_it(ast) do
    ast
  end

  def to_string({_file, ast}) do
    Macro.to_string(ast)
    |> IO.chardata_to_string()
  end
end

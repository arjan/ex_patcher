defmodule ExPatcher do
  def read(file) do
    contents = File.read!(file)
    {:ok, ast} = Code.string_to_quoted(contents)
    {contents, ast}
  end

  def patch_io_chardata_to_string({file, ast}) do
    ast = Macro.postwalk(ast, &fix_chardata_to_string/1)
    {file, ast}
  end

  defp fix_chardata_to_string({:., meta, [{:__aliases__, b, [:IO]}, :char_data_to_string]}) do
    {:., meta, [{:__aliases__, b, [:IO]}, :chardata_to_string]}
  end

  defp fix_chardata_to_string(ast) do
    ast
  end

  def to_string({_file, ast}) do
    Macro.to_string(ast)
    |> IO.chardata_to_string()
  end
end

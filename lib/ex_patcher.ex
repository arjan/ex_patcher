defmodule ExPatcher do
  def read(file) do
    contents = File.read!(file)
    {:ok, ast} = Code.string_to_quoted(contents)
    {contents, ast}
  end

  def patch_io_chardata_to_string({file, ast}) do
    {ast, line} = Macro.postwalk(ast, nil, &fix_chardata_to_string/2)

    if line do
      IO.puts("Found at line: #{line}")
    end

    {file, ast}
  end

  defp fix_chardata_to_string({:., meta, [{:__aliases__, b, [:IO]}, :char_data_to_string]}, _) do
    {{:., meta, [{:__aliases__, b, [:IO]}, :chardata_to_string]}, meta[:line]}
  end

  defp fix_chardata_to_string(ast, acc) do
    {ast, acc}
  end

  def to_string({_file, ast}) do
    Macro.to_string(ast)
    |> IO.chardata_to_string()
  end
end

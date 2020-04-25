# credo:disable-for-this-file
defmodule Mix.Tasks.Gen.Fn do
  use Mix.Task
  require Logger

  @moduledoc """
  A code generator for FunctionFiles. Read more about function_files in the Anakin WIKI: https://github.com/podium/mind_flayer/wiki/FunctionFile-Sourcing-&-CQRS#function_files

  You use it like this:

      mix gen.fn "Org.create(arg1, arg2 \\\\ 0)"

  This will create an function file like this: `lib/anakin/org/create.ex`
  and help you modify `lib/anakin/org.ex`
  """

  @shortdoc "Generates a new function file for facades in Anakin."

  @default_opts []

  def run(args) do
    {_merged_opts, words_after_command, _invalid} = parse_opts(args)
    {function_signature, _fields} = parse_words(words_after_command)

    case parse_signature(function_signature) do
      {:ok, args} ->
        write_files(args)

      {:error, _} ->
        Logger.error(
          "Woops, input wasn't as expected. Should be a function call with double quotes around it, got: #{
            function_signature
          }"
        )

        exit(1)
    end
  end

  defp write_files(args) do
    function_file =
      EEx.eval_file("./lib/mix/tasks/gen/templates/function_file.eex", Enum.into(args, []))

    function_file_test =
      EEx.eval_file("./lib/mix/tasks/gen/templates/function_file_test.eex", Enum.into(args, []))

    modified_facade = modify_or_create_facade(args)

    write_file(args.function_file_path, function_file)
    write_file(args.function_file_test_path, function_file_test)
    update_file(args.facade_file_path, modified_facade)
    System.cmd("mix", ["format"])
  end

  defp parse_signature(signature) do
    with [facade_name, function_call] <- String.split(signature, "."),
         [function_file_name, args_without_parenthesis] <-
           function_call |> String.replace("?", "") |> String.split("(") do
      arguments = "(" <> args_without_parenthesis

      facade_file_name = Macro.underscore(facade_name)

      function_name = Macro.camelize(function_file_name)
      facade_folder_path = "./lib/anakin/#{facade_file_name}"
      facade_test_folder_path = "./test/anakin/#{facade_file_name}"

      {:ok,
       %{
         function_call: function_call,
         facade_name: Macro.camelize(facade_name),
         facade_file_name: facade_file_name,
         facade_file_path: "#{facade_folder_path}/#{facade_file_name}.ex",
         function_name: function_name,
         function_file_name: function_file_name,
         function_file_path: "#{facade_folder_path}/#{function_file_name}.ex",
         facade_folder_path: facade_folder_path,
         function_file_test_folder_path: facade_test_folder_path,
         function_file_test_path: "#{facade_test_folder_path}/#{function_file_name}_test.exs",
         arguments: arguments
       }}
    end
  end

  defp modify_or_create_facade(
         args = %{
           facade_file_path: facade_file_path,
           facade_name: facade_name,
           facade_folder_path: facade_folder_path,
           function_file_test_folder_path: function_file_test_folder_path
         }
       ) do
    File.mkdir_p(facade_folder_path <> "/private")

    if File.exists?(facade_file_path) do
      file_stream = facade_file_path |> File.read!() |> String.split("\n")
      File.mkdir(function_file_test_folder_path)

      file_map = modify_facade(file_stream, args)
      file_map.file
    else
      IO.puts("#{facade_file_path} doesn't exist, creating...")

      contents =
        EEx.eval_file(
          "./lib/mix/tasks/gen/templates/facade.eex",
          facade_name: facade_name
        )

      write_file(facade_file_path, contents)

      modify_or_create_facade(args)
    end
  end

  defp modify_facade(lines, %{
         function_call: function_call,
         facade_name: facade_name,
         function_name: function_file_module,
         function_file_name: function_name
       }) do
    delegate =
      EEx.eval_file(
        "./lib/mix/tasks/gen/templates/delegate.eex",
        function_call: function_call,
        function_file_module: function_file_module,
        function_name: function_name
      )

    first_alias_line_num =
      case lines
           |> Enum.with_index(1)
           |> Enum.find(fn {line, _line_num} -> String.contains?(line, "alias Anakin.") end) do
        nil -> 1
        {_line, line_number} -> line_number
      end

    # insert the alias below the last alias
    new_alias_line = "  alias Anakin.#{facade_name}.#{function_file_module}"

    {alias_lines, normal_lines} =
      Enum.split_with(lines, fn line -> String.contains?(line, "alias") end)

    alias_lines = [new_alias_line, alias_lines] |> Enum.sort()

    lines = List.insert_at(normal_lines, first_alias_line_num, alias_lines) |> List.flatten()

    lines = List.insert_at(lines, length(lines) - 2, delegate)

    %{file: Enum.join(lines, "\n")}
  end

  defp write_file(path, contents) do
    if File.exists?(path) do
      Logger.error("Looks like this file was already generated: #{path}")
      exit(1)
    end

    File.write!(path, contents)
    IO.puts("#{IO.ANSI.green()}File wrote to: #{IO.ANSI.faint()}#{path}#{IO.ANSI.reset()}")
  end

  defp update_file(path, contents) do
    if File.exists?(path) do
      File.write!(path, contents)
      IO.puts("#{IO.ANSI.green()}File modified: #{IO.ANSI.faint()}#{path}#{IO.ANSI.reset()}")
    else
      Logger.error("You must create the file before you update it: #{path}")
      exit(1)
    end
  end

  defp parse_words([function_file_name | unparsed_fields]) do
    Macro.camelize(function_file_name)

    fields =
      unparsed_fields
      |> Enum.map(fn kv ->
        [k, v] = String.split(kv, ":")
        {k, v}
      end)
      |> Enum.into(%{})

    {function_file_name, fields}
  end

  defp parse_words([]) do
    Logger.error(
      "You need to provide the event's file name as the first argument. EG: org_whitelisted_projector"
    )

    exit(1)
  end

  defp parse_opts(args) do
    {opts, words_after_command, invalid} = OptionParser.parse(args, switches: [debug: :boolean])

    merged_opts =
      @default_opts
      |> Keyword.merge(opts)

    {merged_opts, words_after_command, invalid}
  end
end

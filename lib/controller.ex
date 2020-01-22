defmodule Controller do
  @moduledoc """

  """

  @doc """

  """

  def call(input) do
    input_list = String.split(input)

    case length(input_list) do
      0 ->
        "what?"
      _ ->
        IO.inspect(input)
        [command | params] = input_list

        result = try do
          apply(RedisClient, String.to_atom(command), [params])
        rescue
          _e in UndefinedFunctionError -> "No such command"
        end

        result
    end
  end
end

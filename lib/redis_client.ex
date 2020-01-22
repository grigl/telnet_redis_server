defmodule RedisClient do
  @moduledoc """

  """

  @doc """

  """

  @redis_url "redis://localhost:6379/3"

  def set(params) do
    [key, value | _] = params

    fn
      {conn, [key, value]} ->
        case Redix.command(conn, ["SET", key, value]) do
          {:ok, _result} -> IO.puts(:ok); "ok"
          {:error, error} -> IO.inspect(error); "#{inspect error}"
        end
    end |> send_command([key, value])
  end

  def get(params) do
    [key | _]= params

    fn
      {conn, key} ->
        case Redix.command(conn, ["GET", key]) do
          {:ok, result} -> IO.puts(result); result
          {:error, error} -> IO.inspect(error); "#{inspect error}"
        end
    end |> send_command(key)
  end

  defp send_command(func, opts) do
    conn = start_conn()
    result = func.({conn, opts})
    Redix.stop(conn)
    result
  end

  defp start_conn() do
    case Redix.start_link(@redis_url, name: :redix) do
      {:ok, conn} -> conn
      {:error, error} -> IO.inspect(error)
    end
  end
end

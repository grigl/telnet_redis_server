defmodule TelnetRedisServer do
  @moduledoc """
  Documentation for TelnetRedisServer.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TelnetRedisServer.hello()
      :world

  """

  @redis_url "redis://localhost:6379/3"

  def set(key, value) do
    fn
      {conn, [key, value]} ->
        case Redix.command(conn, ["SET", key, value]) do
          {:ok, _result} -> IO.puts(:ok)
          {:error, error} -> IO.inspect(error)
        end
    end |> send_command([key, value])
  end

  def get(key) do
    fn
      {conn, key} ->
        case Redix.command(conn, ["GET", key]) do
          {:ok, result} -> IO.puts(result)
          {:error, error} -> IO.inspect(error)
        end
    end |> send_command(key)
  end

  def send_command(func, opts) do
    conn = start_conn()
    func.({conn, opts})
    Redix.stop(conn)
  end

  defp start_conn() do
    case Redix.start_link(@redis_url, name: :redix) do
      {:ok, conn} -> conn
      {:error, error} -> IO.inspect(error)
    end
  end
end

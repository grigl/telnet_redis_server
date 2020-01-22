defmodule Server do
  @moduledoc """

  """

  @doc """

  """

  @port 6666

  def start do
    case :gen_tcp.listen(@port, [:binary, packet: :line, active: false, reuseaddr: true]) do
      {:ok, socket} ->
        IO.puts(:server_started)
        loop_acceptor(socket)
      {:error, error} -> IO.inspect(error)
    end
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    serve(client)
    loop_acceptor(socket)
  end

  defp serve(socket) do
    socket
    |> read_line()
    |> Controller.call
    |> write_line(socket)

    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    IO.puts("binary? #{is_binary(data)}")
    IO.puts("data #{data}")
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, "#{line}\n")
  end
end

defmodule ElixirHttpServer do

  def main do
    {:ok, port} =
      case System.argv do
       [port_string] -> {:ok, String.to_integer(port_string)}
       not_a_port -> {:error, {:invalid_port, not_a_port}}
      end
    start(port)
  end

  def start(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, {:active, true}, {:reuseaddr, true}])
    IO.puts("Server Listening On http://localhost:#{port}/")
    _accept(socket)
  end

  defp _accept(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    spawn(fn ->
      handle_connection(client)
    end)
    _accept(socket)
  end

  defp handle_connection(client) do
    send_response(client, "HTTP 1.1 200 OK\r\n\r\n\r\n<!DOCTYPE html><head><title>Elixir HTTP Server</title></head><body><h1>Hello, Elixir!</h1><br><a href='https://github.com/0xN1nja' target='_blank'>Abhimanyu Sharma</a></body></html>")
    :ok = :gen_tcp.close(client)
  end

  defp send_response(client, msg) do
    :gen_tcp.send(client, msg)
  end
end

ElixirHttpServer.main()

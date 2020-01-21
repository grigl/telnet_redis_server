defmodule TelnetRedisServerTest do
  use ExUnit.Case
  doctest TelnetRedisServer

  test "greets the world" do
    assert TelnetRedisServer.hello() == :world
  end
end

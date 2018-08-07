defmodule RpEventbusTest do
  use ExUnit.Case
  doctest RpEventbus

  test "greets the world" do
    assert RpEventbus.hello() == :world
  end
end

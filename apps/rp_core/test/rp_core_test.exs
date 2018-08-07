defmodule RpCoreTest do
  use ExUnit.Case
  doctest RpCore

  test "greets the world" do
    assert RpCore.hello() == :world
  end
end

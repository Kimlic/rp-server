defmodule RpHttpTest do
  use ExUnit.Case
  doctest RpHttp

  test "greets the world" do
    assert RpHttp.hello() == :world
  end
end

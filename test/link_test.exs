defmodule LinkTest do
  use ExUnit.Case
  doctest Link

  test "greets the world" do
    assert Link.hello() == :world
  end
end

defmodule JotterTest do
  use ExUnit.Case
  doctest Jotter

  test "greets the world" do
    assert Jotter.hello() == :world
  end
end

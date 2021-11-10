defmodule MinifiledbTest do
  use ExUnit.Case

  test "write to file" do
    Minifiledb.init()
    
    Minifiledb.write(1, "Hello")
    Minifiledb.write(2, "World")
    Minifiledb.write(2, "This")
    Minifiledb.write(4, "Is")
    Minifiledb.write(5, "Khanh")
    Minifiledb.write(6, "Talking")
    Minifiledb.write(7, "Above")

    assert Minifiledb.read(1) == "Hello"
    assert Minifiledb.read(7) == "Above"
    
    Minifiledb.terminate()
  end

  test "write and compact" do
    Minifiledb.init()
    1..26
    |> Enum.to_list()
    |> Enum.map(fn x -> %{ key: x, val: "Hello.#{x}"} end) 
    |> Enum.map(fn x -> Minifiledb.write(x.key, x.val) end)

    assert Minifiledb.read(1) == "Hello.1"
    assert Minifiledb.read(6) == "Hello.6"
    assert Minifiledb.read(26) == "Hello.26"

    Minifiledb.terminate()
  end
end

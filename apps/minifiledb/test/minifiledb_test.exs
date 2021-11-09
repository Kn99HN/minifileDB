defmodule MinifiledbTest do
  use ExUnit.Case

  test "write to file" do
    Minifiledb.init()
    
    Minifiledb.write(1, "Hello")
    Minifiledb.write(2, "World")
    Minifiledb.write(2, "This")
    #Minifiledb.write(4, "Is")
    #Minifiledb.write(5, "Khanh")
    #Minifiledb.write(6, "Talking")
    #Minifiledb.write(7, "Above")

    #assert Minifiledb.read(1) == "Hello"
    #assert Minifiledb.read(7) == "Above"

    Minifiledb.terminate()
  end
end

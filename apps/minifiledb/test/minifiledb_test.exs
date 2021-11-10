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

  defp generate(seq) do
    seq |> Enum.to_list()
    |> Enum.map(fn x -> %{ key: x, val: "Hello.#{x}"} end) 
    |> Enum.map(fn x -> Minifiledb.write(x.key, x.val) end)

  end

  test "write and compact" do
    Minifiledb.init()
    generate(1..26)

    assert Minifiledb.read(1) == "Hello.1"
    assert Minifiledb.read(6) == "Hello.6"
    assert Minifiledb.read(26) == "Hello.26"

    Minifiledb.terminate()
  end

  defp read do
    assert Minifiledb.read(1) == "Hello.1"
    assert Minifiledb.read(2) == "Hello.2"
  end

  test "concurrent reads" do
    Minifiledb.init()

    generate(1..10)

    tasks = [Task.async(fn -> read end), Task.async(fn -> read end)]
    Task.yield_many(tasks)

    Minifiledb.terminate()
  end

  def write(seq) do
    generate(seq)

    assert Minifiledb.read(16) == "Hello.16"
  end

  test "concurrent writes" do
    Minifiledb.init()

    tasks = [Task.async(fn -> write(1..16) end), Task.async(fn -> write(5..21) end)]

    Task.yield_many(tasks)

    Minifiledb.terminate()
  end
end

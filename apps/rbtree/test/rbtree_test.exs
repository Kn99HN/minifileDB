defmodule RbtreeTest do
  use ExUnit.Case
  doctest Rbtree

  test "test" do
    tree = Rbtree.init()
    node1 = %Node{
      key: 1,
      val: 2
    }
    node2 = %Node{
      key: 2,
      val: 3
    }
    tree = Rbtree.insert(tree, node1)
    tree = Rbtree.insert(tree, node2)
    IO.puts("#{inspect(tree)}")
  end
end

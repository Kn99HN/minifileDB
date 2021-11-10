defmodule RbtreeTest do
  use ExUnit.Case
  doctest Rbtree

  test "test" do
    tree = Rbtree.init()
    node1 = %Node{
      key: 1,
      val: "Hello"
    }
    node2 = %Node{
      key: 2,
      val: "World"
    }
    node3 = %Node{
      key: -1,
      val: "THis"
    }
    node4 = %Node{
      key: 2,
      val: "THis"
    }
    node5 = %Node{
      key: 5,
      val: "THis"
    }



    tree = Rbtree.insert(tree, node1)
    tree = Rbtree.insert(tree, node2)
    tree = Rbtree.insert(tree, node3)
    tree = Rbtree.insert(tree, node4)
    tree = Rbtree.insert(tree, node5)
    assert tree.height == 4
  end

  test "test imbalanced tree" do
    tree = Rbtree.init()
    node1 = %Node{
      key: 1,
      val: "Hello"
    }
    node2 = %Node{
      key: 2,
      val: "World"
    }
    node3 = %Node{
      key: 10,
      val: "THis"
    }



    tree = Rbtree.insert(tree, node1)
    tree = Rbtree.insert(tree, node2)
    tree = Rbtree.insert(tree, node3)
    assert tree.root.right.right == node3
  end
end

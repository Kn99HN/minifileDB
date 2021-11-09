defmodule Node do
  alias __MODULE__

  @enforce_keys [:key, :val]
  defstruct(
    key: nil,
    val: nil,
    #color: nil,
    #parent: nil,
    left: nil,
    right: nil
  )
end

defmodule Rbtree do
  # @ToDo: convert this to a RB tree
  def init() do
    nil
  end

  def insert(root, node) do
    case root do
      nil -> node
      root ->
        cond do
          node.key < root.key -> %{root | left: insert(root.left, node)}
          node.key > root.key -> %{root | right: insert(root.right, node)}
          node.key == root.key -> root
        end
    end
  end
end

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
  defstruct(tree: nil, height: 0)
  # @ToDo: convert this to a RB tree
  def init() do
    %Rbtree{ tree: nil, height: 0}
  end

  def insert(root, node) do
    case root.tree do
      nil -> node
      current ->
        cond do
          node.key < current.key -> 
            new_tree = %{current | left: insert(root.left, node)}
            %Rbtree{tree: new_tree, height: current.height + 1}
          node.key > current.key -> 
            new_tree = %{current | right: insert(root.right, node)}
            %Rbtree{tree: new_tree, height: current.height + 1}
          node.key == current.key -> root
        end
    end
  end

  def search(root, key) do
    cond do
      root == nil -> nil
      key < root.key -> search(root.left, key)
      key > root.key -> search(root.right, key)
      key == root.key -> root.val
    end
  end

end
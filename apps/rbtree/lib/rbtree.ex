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
  defstruct(root: nil, height: 0)
  # @ToDo: convert this to a RB tree
  def init() do
    %Rbtree{ root: nil, height: 0}
  end

  defp insert_node(root, node) do
    case root do
      nil 
        -> {:ok, node}
      treenode ->
        cond do
          node.key < treenode.key ->
            case insert_node(treenode.left, node) do
              {:ok, node} -> {:ok, %{ root | left: node }}
              {:notok} -> {:notok}
            end
          node.key > treenode.key ->
            case insert_node(treenode.right, node) do
              {:ok, node} -> 
                {:ok, %{ root | right: node}}
              {:notok} -> {:notok}
            end
          node.key == treenode.key -> {:notok}
        end
    end
  end

  def insert(tree, node) do
    case insert_node(tree.root, node) do
      {:ok, newtree} -> %Rbtree{ root: newtree, height: tree.height + 1}
      {:notok} -> tree
    end
  end

  defp search_key(root, key) do
    cond do
      root == nil -> nil
      key == root.key or "#{key}" == root.key -> root.val
      key < root.key -> search_key(root.left, key)
      key > root.key -> search_key(root.right, key)
    end
  end

  def search(tree, key) do
    search_key(tree.root, key)
  end

  defp to_str(root, ls) do
    case root do
      nil -> ls
      root ->
        key = root.key
        val = root.val
        ["#{key}:#{val}"] ++ to_str(root.left, ls) ++ to_str(root.right, ls)
    end
  end

  def to_str(tree) do
    outputs = to_str(tree.root, [])
    Enum.join(outputs, ",")
  end

end

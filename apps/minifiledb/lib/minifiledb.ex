defmodule Minifiledb do
  
  @thresh_hold=20

  defstruct(
    tree: Rbtree.init()
  )

  def init() do
    try do
      Agent.stop(:filetree)
    catch
      :exit, _ -> true
    end
    Agent.start_link(fn -> %Minifiledb{ tree: Rbtree.init() } end, name: :filetree)
  end

  def terminate do
    try do
      Agent.stop(:filetree)
    catch
      :exit, _ -> true
    end
  end

  def write(key, val) do
    db = Agent.get(:filetree, fn db -> db.tree end)
    if db.heights > @thresh_hold do
      # write db to segment file
      Agent.update(:filetree, fn db -> %Minifiledb { tree: Rbtree.init() } end)
    else
      Agent.update(:filetree, fn db -> 
        tree = db.tree
        %{db | tree: Rbtree.insert(tree, %Rbtree.Node{ key: key, val: val })
      end)
    end
  end

  def read(key) do
    Agent.get(:filetree, fn db -> Rbtree.search(db.tree, key) end)
  end
end

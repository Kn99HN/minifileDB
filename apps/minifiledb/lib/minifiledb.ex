defmodule Minifiledb do
  @thresh_hold=20

  defstruct(
    tree: Rbtree.init(),
    segment: 1,
    index_table: %{}
  )

  def init() do
    try do
      Agent.stop(:filetree)
    catch
      :exit, _ -> true
    end
    Agent.start_link(fn -> %Minifiledb{ 
      tree: Rbtree.init(),
      segment: 1,
      index_table: %{}
     } end, name: :filetree)
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
    if db.height > @thresh_hold do
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
    Agent.get(:filetree, fn db -> 
      res = Rbtree.search(db.tree, key)
      if res == nil do
        read_from_segment(key)
      else
        res
      end
    end)
  end

  defp parse_to_binary_tree(tree, strs) do
    case strs do
      [] -> tree
      [head | tail] ->
        ls = String.split(strs, ":", trim: true)
        node = %Rbtree.Node{ key: Enum.at(ls, 0), val: Enum.at(ls, 1) }
        tree = Rbtree.insert(tree, node)
        parse_to_binary_tree(tree, tail)
    end
  end

  defp read_segment_file_and_read(files, key) do
    case files do
      [] -> nil
      [head | tail] ->
        case File.read(head) do
          {:ok, body} ->
            rbtree = parse_to_binary_tree(Rbtree.init(), String.split(body, ","))
            result = search(rbtree.tree, key)
            if result == nil do
              read_segment_file_and_read(tail, key)
            else
              result
            end
          {:error, reason} ->
            raise "PANIC @ THE DISCO"
        end
    end
  end

  def read_from_segments(key) do
    segment_file_path = System.get_env("SEGMENT_FILES")
    case File.ls(segment_file_path) do
      {:ok, files} ->
        result = read_segment_file_and_read(files, key) 
        if result == nil do
          nil
        else
          result
        end
      {:error, reason} -> raise "PANIC @ THE DISCO"
    end
  end
end

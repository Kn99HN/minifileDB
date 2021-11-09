defmodule Minifiledb do
  @thresh_hold 5

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
    db = Agent.get(:filetree, fn db -> db end)
    tree = db.tree
    if tree.height == @thresh_hold do
      segment_path = System.get_env("SEGMENT_FILES")
      segment_file = Enum.join(["segment", db.segment], "-")
      segment_file_path = "#{segment_path}/#{segment_file}.txt"
      #case File.touch!(segment_file_path) do
      #  :ok ->
      #            {:error, reason} -> 
      #    raise "#{inspect(reason)}"
      #end
      case File.open(segment_file, [:append]) do
            {:ok, file} ->
              IO.binwrite(file, Rbtree.to_str(tree))
           {:error, reason} -> raise "PANIC @ THE DISCO"
      end

      Agent.update(:filetree, fn db -> 
        node = %Node{ key: key, val: val}
        new_tree = Rbtree.insert(Rbtree.init(), node)
        %Minifiledb { 
          tree: new_tree,
          segment: db.segment + 1,
          index_table: %{}
        } end)
    else
      Agent.update(:filetree, fn db -> 
        tree = db.tree
        %{db | tree: Rbtree.insert(tree, %Node{ key: key, val: val })}
      end)
    end
  end

  def read(key) do
    Agent.get(:filetree, fn db -> 
      res = Rbtree.search(db.tree, key)
      if res == nil do
        read_from_segments(key)
      else
        res
      end
    end)
  end

  defp parse_to_binary_tree(tree, strs) do
    case strs do
      [] -> tree
      [head | tail] ->
        ls = String.split(head, ":", trim: true)
        node = %Node{ key: Enum.at(ls, 0), val: Enum.at(ls, 1) }
        tree = Rbtree.insert(tree, node)
        parse_to_binary_tree(tree, tail)
    end
  end

  defp read_segment_file_and_read(files, key) do
    case files do
      [] -> nil
      [head | tail] ->
        if String.contains?(head, "segment") do
          case File.read(head) do
            {:ok, body} ->
              rbtree = parse_to_binary_tree(Rbtree.init(), String.split(body, ","))
              IO.puts("#{inspect(rbtree)}")
              result = Rbtree.search(rbtree, key)
              if result == nil do
                read_segment_file_and_read(tail, key)
              else
                result
              end
            {:error, reason} ->
              raise "PANIC @ THE DISCO"
          end
       else
        read_segment_file_and_read(tail, key)
       end
    end
  end

  def read_from_segments(key) do
    segment_file_path = System.get_env("SEGMENT_FILES")
    case File.ls(".") do
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

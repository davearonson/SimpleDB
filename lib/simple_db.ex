defmodule SimpleDB do
  use GenServer

  @moduledoc """
  `SimpleDB` is a demo of using a GenServer as a simple database,
  inside an application with an OTP supervision tree.
  """

  @doc """
  Starts the database.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Creates an item in the database, with the given ID.
  """
  def create(db, id) do
    GenServer.call(db, {:create, id})
  end

  @doc """
  Deletes an item from the database, with the given ID.
  """
  def delete(db, id) do
    GenServer.call(db, {:delete, id})
  end

  @doc """
  Deletes the value with the given key,
  from the item in the database with the given ID.
  """
  def delete_key(db, id, key) do
    GenServer.call(db, {:delete_key, id, key})
  end

  @doc """
  Deletes all items from the database.
  """
  def empty!(db) do
    GenServer.call(db, {:empty!})
  end

  @doc """
  Reads an item from the database, with the given ID.
  """
  def read(db) do
    GenServer.call(db, {:read})
  end

  @doc """
  Reads the value with the given key,
  from the item in the database with the given ID.
  """
  def read(db, id) do
    GenServer.call(db, {:read, id})
  end

  @doc """
  Updates or inserts the value under the given key,
  on the item in the database with the given ID.
  """
  def upsert(db, id, key, value) do
    GenServer.call(db, {:upsert, id, key, value})
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:create, id}, _from, items) do
    if Map.has_key?(items, id) do
      {:reply, "Error: id #{id} already exists", items}
    else
      {:reply, "OK", Map.put(items, id, %{})}
    end
  end

  @impl true
  def handle_call({:delete, id}, _from, items) do
    {:reply, "OK", Map.delete(items, id)}
  end

  @impl true
  def handle_call({:delete_key, id, key}, _from, items) do
    item = items[id]
    new_item = Map.delete(item, key)
    {:reply, "OK", %{items | id => new_item}}
  end

  @impl true
  def handle_call({:empty!}, _from, _items) do
    {:reply, "OK", %{}}
  end

  @impl true
  def handle_call({:read}, _from, items) do
    {:reply, items, items}
  end

  @impl true
  def handle_call({:read, id}, _from, items) do
    {:reply, items[id], items}
  end

  @impl true
  def handle_call({:upsert, id, key, value}, _from, items) do
    item = items[id]
    new_item = Map.put(item, key, value)
    {:reply, new_item, %{items | id => new_item}}
  end
end

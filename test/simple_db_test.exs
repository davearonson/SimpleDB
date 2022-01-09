defmodule SimpleDBTest do
  use ExUnit.Case
  doctest SimpleDB

  test "stores values by key" do
    db = start_supervised!(SimpleDB)

    id1 = "whatever"

    assert SimpleDB.read(db) == %{}
    assert SimpleDB.read(db, id1) == nil

    SimpleDB.create(db, id1)
    assert SimpleDB.read(db) == %{id1 => %{}}
    assert SimpleDB.read(db, id1) == %{}

    k1 = "some initial key"
    v1 = "some initial value"

    SimpleDB.upsert(db, id1, k1, v1)
    assert SimpleDB.read(db, id1) == %{k1 => v1}

    v1b = "some replacement key"

    SimpleDB.upsert(db, id1, k1, v1b)
    assert SimpleDB.read(db, id1) == %{k1 => v1b}

    k2 = "some other key"
    v2 = "some other value"

    SimpleDB.upsert(db, id1, k2, v2)
    assert SimpleDB.read(db, id1) == %{k1 => v1b, k2 => v2}

    SimpleDB.delete_key(db, id1, k1)
    assert SimpleDB.read(db, id1) == %{k2 => v2}

    id2 = "whatever else"

    SimpleDB.create(db, id2)
    assert SimpleDB.read(db) == %{id1 => %{k2 => v2}, id2 => %{}}
    assert SimpleDB.read(db, id2) == %{}

    SimpleDB.delete(db, id1)
    assert SimpleDB.read(db) == %{id2 => %{}}
    assert SimpleDB.read(db, id1) == nil
    assert SimpleDB.read(db, id2) == %{}

    SimpleDB.empty!(db)
    assert SimpleDB.read(db) == %{}
  end

end

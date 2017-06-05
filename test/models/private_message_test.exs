defmodule EopChatBackend.PrivateMessageTest do
  use EopChatBackend.ModelCase

  alias EopChatBackend.PrivateMessage

  @valid_attrs %{content: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PrivateMessage.changeset(%PrivateMessage{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PrivateMessage.changeset(%PrivateMessage{}, @invalid_attrs)
    refute changeset.valid?
  end
end

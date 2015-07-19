defmodule Rhein.Dht.Messages do
  import Rhein.Bencode

  @doc """

  Build a find_node message.

  ## Examples

    iex> Rhein.Dht.Messages.find_node("token", "id", "target")
    "d1:ad2:id2:id6:target6:targete1:q9:find_node1:t5:token1:y1:qe"

    iex> Rhein.Bencode.decode(Rhein.Dht.Messages.find_node("token", "id", "target"))
    { %{"t" => "token", "y" => "q", "q" => "find_node", "a" => %{ "id" => "id", "target" => "target"}}, "" }

  """
  def find_node(token, id, target) do
    %{
      t: token,
      y: "q",
      q: "find_node",
      a: %{
        id: id,
        target: target
      }
    }
    |> encode
  end

  @doc """

  Build an answer to a ping.

  ## Examples

    iex> Rhein.Dht.Messages.answer_ping("token", "id")
    "d1:rd2:id2:ide1:t5:token1:y1:re"

    iex> Rhein.Bencode.decode(Rhein.Dht.Messages.answer_ping("token", "id"))
    { %{ "t" => "token", "y" => "r", "r" => %{ "id" => "id"}}, "" }

  """
  def answer_ping(token, id) do
    %{
      t: token,
      y: "r",
      r: %{
        id: id,
      }
    }
    |> encode
  end

end

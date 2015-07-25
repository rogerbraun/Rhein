require Bitwise
defmodule Rhein.Dht.Node do
  defstruct id: nil

  @doc """

  Calulate the distance between two nodes. This just their IDs XORed.

  ## Examples

    iex> Rhein.Dht.Node.distance(%Rhein.Dht.Node{id: << 10::integer-160>> }, %Rhein.Dht.Node{id: << 7::integer-160 >>})
    13
  """
  def distance(%Rhein.Dht.Node{id: id}, %Rhein.Dht.Node{id: other_id}) do
    << node_as_integer::integer-160 >> = id
    << other_node_as_integer::integer-160 >> = other_id

    Bitwise.bxor(node_as_integer, other_node_as_integer)
  end
end

defmodule Rhein.Bencode do

  @doc """

  Encode Atoms, Strings, Lists and Maps to the Bencode format.

  ## Examples

    iex> Rhein.Bencode.encode("Hello")
    "5:Hello"

    iex> Rhein.Bencode.encode(:Hello)
    "5:Hello"

    iex> Rhein.Bencode.encode(123)
    "i123e"

    iex> Rhein.Bencode.encode([123, "Hello"])
    "li123e5:Helloe"

    iex> Rhein.Bencode.encode(%{a: 1, b: "Hello"})
    "d1:ai1e1:b5:Helloe"

  """
  def encode(atom) when is_atom(atom), do: encode(to_string(atom))

  def encode(number) when is_integer(number) do
    "i#{number}e"
  end

  def encode(bytes) when is_binary(bytes) do
    "#{byte_size(bytes)}:" <> bytes
  end

  def encode(list) when is_list(list) do
    encoded_list = list
    |> Enum.map(&encode/1)
    |> Enum.join

    "l#{encoded_list}e"
  end

  def encode(map) when is_map(map) do
    encode_tuple = fn({key, value}) -> encode(key) <> encode(value) end
    sort_by_key = fn({key, _}, {other_key, _}) -> key <= other_key end
    wrap_dict = fn(binary) -> "d" <> binary <> "e" end

    map
    |> Enum.to_list
    |> Enum.sort(sort_by_key)
    |> Enum.map(encode_tuple)
    |> Enum.join
    |> wrap_dict.()
  end


  @doc """
  Decode Bencoded binaries. Returns a tuple with the result and the remaining
  binary.

  ## Examples

    iex> Rhein.Bencode.decode("5:Hello")
    {"Hello", ""}

    iex> Rhein.Bencode.decode("i123e")
    {123, ""}

    iex> Rhein.Bencode.decode("li123e5:Helloe")
    {[123, "Hello"], ""}

    iex> Rhein.Bencode.decode("d1:ai123e1:b5:Helloe")
    {%{"a" => 123, "b" => "Hello"}, ""}
  """
  # Integers
  def decode(<< ?i, rest::binary >>) do
    r = ~r/^(-?\d+)e(.*)/
    [_, number, rest] = Regex.run(r, rest)
    {String.to_integer(number), rest}
  end

  # Lists
  def decode(<< ?l, rest::binary >>) do
    {reverse_decoded, rest} = decode_elements([], rest)
    {Enum.reverse(reverse_decoded), rest}
  end

  def decode_elements(decoded, << ?e, rest::binary >>) do
    {decoded, rest}
  end

  def decode_elements(decoded, encoded) do
    {new_element, rest} = decode(encoded)
    decode_elements([new_element | decoded], rest)
  end

  # Dicts
  def decode(<< ?d, rest::binary >>) do
    {reverse_decoded, rest} = decode_elements([], rest)
    map = reverse_decoded
    |> Enum.reverse
    |> Enum.chunk(2)
    |> Enum.map(&List.to_tuple/1)
    |> Enum.into(%{})
    {map, rest}
  end

  # Strings / Binaries
  def decode(string) do
    r = ~r/^(\d+):(.*)/
    [_, size, rest] = Regex.run(r, string)
    size = String.to_integer(size)
    << data::binary-size(size), rest::binary >> = rest
    {data, rest}
  end
end

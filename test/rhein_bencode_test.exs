defmodule RheinTest.Bencode do
  use ExUnit.Case
  import Rhein.Bencode

  test "Encode integers" do

    positive_number = 1092342
    negative_number = -1243422
    zero = 0

    assert encode(positive_number) == "i1092342e"
    assert encode(negative_number) == "i-1243422e"
    assert encode(zero) == "i0e"
  end

  test "Encode bytes" do
    string = "Hello"
    binary = << 1, 2, 3, 4 >>

    assert encode(string) == "5:Hello"
    assert encode(binary) == "4:" <> << 1, 2, 3, 4 >>
  end

  test "Encode Lists" do
    list = [3, "Hello"]

    assert encode(list) == "l" <> encode(3) <> encode("Hello") <> "e"
  end

  test "Encode Dictionaries" do
    map = %{a: 1, b: "Hello"}

    result = "d1:ai1e1:b5:Helloe"

    assert encode(map) == result
  end

  test "Decode Integers" do
    ten = "i10e"
    minus_twenty = "i-20e"
    zero = "i0e"

    assert decode(ten) == {10, ""}
    assert decode(minus_twenty) == {-20, ""}
    assert decode(zero) == {0, ""}
  end

  test "Decode Strings" do
    string = "5:Hello"

    assert decode(string) == {"Hello", ""}
  end

  test "Decode Lists" do
    list = [1, "Hello"]
    encoded_list = encode(list)

    assert decode(encoded_list) == {list, ""}
  end

  test "Decode Dicts" do
    map = %{"a" => 1, "b" => "Hello"}
    encoded_dict = encode(map)

    assert decode(encoded_dict) == {map, ""}
  end

end

defmodule LinkRegexTest do
  use ExUnit.Case
  alias NimbleCSV.RFC4180, as: CSV

  test "Link.regex/0 returns a Regular Expression" do
    assert Regex.run(Link.regex(), "https://www.dwyl.com")
    assert Regex.run(Link.regex(), "http://www.links.net")
    # no protocol
    assert Regex.run(Link.regex(), "google.com") == ["google.com", ""]
    assert Regex.run(Link.regex(), "https://git.io/top")
  end

  # stackoverflow.com/a/51391095/1148249
  def bool!(" true"), do: true
  def bool!(" false"), do: false

  def csv_lines do
    "test/sample_urls.csv"
    |> File.read!
    |> CSV.parse_string()
    # |> dbg()
  end

  test "Link.valid?/1 Test many URLs in sample_urls.csv" do
    csv_lines() |> Enum.each(fn x ->
      # e.g: https://www.example.com, true
      assert Link.valid?(List.first(x)) == bool!(List.last(x))
      # IO.inspect("#{List.first(x)}, #{List.last(x)}, #{to_string(Link.valid?(List.first(x)))}")
    end)
  end

  test "Link.find/1 returns all links in a block of text" do
    text = "text has.com links http://www.links.net in it"
    assert Link.find(text) == ["has.com", "http://www.links.net"]
  end

  test "Link.find/1 works for a multi-line string:" do
    multi = """
    This string has multiple https://mvp.fly.dev/ links.
    Long links https://github.com/nelsonic/nelsonic.github.io/issues/733 and
    comments: https://github.com/dwyl/mvp/issues/141#issuecomment-1657954420
    also get extracted.
    """

    assert Link.find(multi) == [
             "https://mvp.fly.dev/",
             "https://github.com/nelsonic/nelsonic.github.io/issues/733",
             "https://github.com/dwyl/mvp/issues/141#issuecomment-1657954420"
           ]
  end

  # test "Link.compact_github_url/1 distils a repo deep link down to the minimum" do
  #   url = "https://github.com/dwyl/app#what"
  #   assert Link.compact(url) == "dwyl/app"
  # end
end

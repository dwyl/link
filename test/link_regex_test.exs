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
    |> File.read!()
    |> CSV.parse_string()
  end

  test "Link.valid?/1 Test many URLs in sample_urls.csv" do
    csv_lines()
    |> Enum.each(fn x ->
      # e.g: https://www.example.com, true
      assert Link.valid?(List.first(x)) == bool!(List.last(x))
      # IO.inspect("#{List.first(x)}, #{List.last(x)}, #{to_string(Link.valid?(List.first(x)))}")
    end)
  end

  test "Link.find/1 returns all links in a block of text" do
    text = "text has.com links http://www.links.net in it"
    assert Link.find(text) == ["http://www.links.net", "has.com"]
  end

  # Ref: github.com/dwyl/link/issues/6
  test "Link.find/1 should avoid strings with 3 or more dots e.g: ...something" do
    text = "text has.com links http://www.links.net in it ...something"
    assert Link.find(text) == ["http://www.links.net", "has.com"]
  end

  test "Link.find/1 works for a multi-line string:" do
    multi = """
    This string has multiple https://mvp.fly.dev/ links.
    Long links https://github.com/nelsonic/nelsonic.github.io/issues/733 and
    comments: https://github.com/dwyl/mvp/issues/141#issuecomment-1657954420
    also get extracted.
    """

    assert Link.find(multi) == [
             "https://github.com/dwyl/mvp/issues/141#issuecomment-1657954420",
             "https://github.com/nelsonic/nelsonic.github.io/issues/733",
             "https://mvp.fly.dev/"
           ]
  end

  test "Link.find_replace_compact/1 replaces long urls with compact Markdown links" do
    multi = """
    This string has multiple https://mvp.fly.dev/ links.
    Long links https://github.com/nelsonic/nelsonic.github.io/issues/733 and
    comments: https://github.com/dwyl/mvp/issues/141#issuecomment-1657954420
    also get extracted.
    But existing markdown links [mvp](https://mvp.fly.dev) and images
    ![gif](https://media.giphy.com/media/V2qjQASrLwLuwpagjI/giphy.gif)
    are left alone.
    """

    expected = """
    This string has multiple [mvp.fly.dev](https://mvp.fly.dev/) links.
    Long links [nelsonic/nelsonic.github.io#733](https://github.com/nelsonic/nelsonic.github.io/issues/733) and
    comments: [dwyl/mvp#141](https://github.com/dwyl/mvp/issues/141#issuecomment-1657954420)\nalso get extracted.
    But existing markdown links [mvp](https://mvp.fly.dev) and images
    ![gif](https://media.giphy.com/media/V2qjQASrLwLuwpagjI/giphy.gif)
    are left alone.
    """

    # Link.find_replace_compact(multi) |> dbg()
    assert Link.find_replace_compact(multi) == expected
  end

  test "Link.find_replace_compact/1 PR links" do
    pr_md = """
    My awesome PR link: https://github.com/dwyl/link/pull/5
    and comment one too: https://github.com/dwyl/link/pull/5#pullrequestreview-1558913764
    """

    expected = """
    My awesome PR link: [dwyl/link/PR#5](https://github.com/dwyl/link/pull/5)
    and comment one too: [dwyl/link/PR#5](https://github.com/dwyl/link/pull/5#pullrequestreview-1558913764)
    """

    # Link.find_replace_compact(pr_md) |> dbg()
    assert Link.find_replace_compact(pr_md) == expected
  end

  test "Link.find_replace_compact/1 PR link without any other text" do
    pr_md = """

    https://github.com/dwyl/link/pull/5#pullrequestreview-1558913764


    """

    expected = """

    [dwyl/link/PR#5](https://github.com/dwyl/link/pull/5#pullrequestreview-1558913764)


    """

    # Link.find_replace_compact(pr_md) |> dbg()
    assert Link.find_replace_compact(pr_md) == expected
  end
end

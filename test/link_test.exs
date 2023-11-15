defmodule LinkTest do
  use ExUnit.Case
  doctest Link

  test "Link.compact/1 compacts a URL" do
    assert Link.compact("https://github.com/dwyl/mvp/issues/141") == "dwyl/mvp#141"
  end

  test "Link.compact/1 compacts comment URL" do
    assert Link.compact("https://github.com/dwyl/mvp/issues/141#issuecomment-1657954420") ==
             "dwyl/mvp#141"
  end

  test "Link.compact_github_url/1 compacts a Pull Request Link" do
    url = "https://github.com/dwyl/link/pull/5"
    assert Link.compact(url) == "dwyl/link/PR#5"

    comment = "https://github.com/dwyl/link/pull/5#pullrequestreview-1558913764"
    assert Link.compact(comment) == "dwyl/link/PR#5"
  end

  test "Link.compact/1 returns unrecognized url unmodified" do
    url = "https://git.io/top"
    assert Link.compact(url) == "git.io/top"
  end

  test "Link.strip_protocol/1 returns url without https:// or http://" do
    url = "https://git.io/top"
    assert Link.strip_protocol(url) == "git.io/top"

    url2 = "http://google.com"
    assert Link.strip_protocol(url2) == "google.com"
  end

  test "Link.compact_github_url/1 distils a repo deep link down to the minimum" do
    url = "https://github.com/dwyl/app#what"
    assert Link.compact(url) == "dwyl/app"
  end

  test "Link.find_replace_compact/1 does not leave @spacer in" do
    text = "Buy Bananas"
    assert Link.find_replace_compact(text) == text
  end
end

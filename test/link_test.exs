defmodule LinkTest do
  use ExUnit.Case
  doctest Link

  test "Link.compact/1 compacts a URL" do
    assert Link.compact("https://github.com/dwyl/mvp/issues/141") == "dwyl/mvp#141"
  end

  test "Link.compact/1 returns unrecognized url unmodified" do
    url = "https://git.io/top"
    assert Link.compact(url) == url
  end

  test "Link.compact_github_url/1 distils a repo deep link down to the minimum" do
    url = "https://github.com/dwyl/app#what"
    assert Link.compact(url) == "dwyl/app"
  end
end

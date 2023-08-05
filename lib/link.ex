defmodule Link do
  @moduledoc """
  `Link` is a little link parsing, compacting and shortening library.
  """

  @doc """
  `compact/1` reduces a url to its most compact form.
  This is highly specific to our use case.

  ## Examples

      iex> Link.compact("https://github.com/dwyl/mvp/issues/141")
      "dwyl/mvp#141"

      # Can't understand the URL, just return it sans protocol:
      iex> Link.compact("https://git.io/top")
      "git.io/top"

      iex> Link.compact("https://mvp.fly.dev/")
      "mvp.fly.dev"

  """
  def compact(url) do
    # This uses cond instead of "if" because it will expand soon!
    cond do
      String.contains?(url, "github") ->
        compact_github_url(url)

      true ->
        url
        |> strip_protocol()
        |> strip_trailing_slash()
    end
  end

  @doc """
  `compact_github_url/1` does exactly as its' name implies:
  compact a GitHub URL down to it's simplest version
  so that we aren't wasting characters on a mobile screen.

  ## Examples

      iex> Link.compact_github_url("https://github.com/dwyl/mvp/issues/141")
      "dwyl/mvp#141"

      iex> Link.compact_github_url("https://github.com/dwyl/app/issues/275#issuecomment-1646862277")
      "dwyl/app#275"

      iex> Link.compact_github_url("https://github.com/dwyl/link#123")
      "dwyl/link"

      iex> Link.compact_github_url("https://github.com/dwyl/link/pull/5")
      "dwyl/link/PR#5"
  """
  def compact_github_url(url) do
    # Remove any hash (#) URL params, remove "https://" and "github.com/"
    clean =
      String.split(url, "#")
      |> List.first()
      |> strip_protocol()
      |> String.replace("github.com/", "")

    cond do
      # "dwyl/mvp/issues/141"
      String.contains?(url, "/issues/") ->
        parts = String.split(clean, "/")
        org = Enum.at(parts, 0)
        project = Enum.at(parts, 1)
        issue_number = Enum.at(parts, 3)

        # Assemble into the compact form:
        "#{org}/#{project}##{issue_number}"

      # dwyl/link/pull/5
      String.contains?(url, "/pull/") ->
        parts = String.split(clean, "/")
        org = Enum.at(parts, 0)
        project = Enum.at(parts, 1)
        pr_number = Enum.at(parts, 3)

        # Assemble into the compact form:
        "#{org}/#{project}/PR##{pr_number}"

      true ->
        # Orgs, People or Repos just return path e.g: "dwyl/app" or "iteles"
        clean
    end
  end

  @doc """
  `strip_protocol/1` strips the protocol e.g: "https://" from a URL.

  ## Examples

      iex> Link.strip_protocol("https://dwyl.com")
      "dwyl.com"
  """
  def strip_protocol(url) do
    String.replace(url, ~r"(http(s)?):\/\/", "")
  end

  @doc """
  `strip_trailing_slash/1` strips trailing forward slash from URL.

  ## Examples

      iex> Link.strip_trailing_slash("dwyl.com/")
      "dwyl.com"
  """
  def strip_trailing_slash(url) do
    if String.ends_with?(url, "/") && url != "/" do
      String.slice(url, 0..-2)
    else
      url
    end
  end

  @doc """
  `regex/0` returns the Regular Expression needed to match URLs.
  According to `RFC 3986`: https://www.rfc-editor.org/rfc/rfc3986
  Based on reading https://mathiasbynens.be/demo/url-regex
  After much searching on Google, GitHub and StackOverflow,
  this is what we came up with.

  #HELPWANTED: if you find a *better* (faster, more comppliant) RegEx
  that passes all our tests, please share! github.com/dwyl/link/issues/new

  Explanation:

  ((http(s)?):\/\/             # Optional scheme (http or https)
  (www\.)?                     # Optional "www"
  a-zA-Z0-9@:%._\+~#=]{2,256}  # Domain (IPv4, IPv6 or hostname)
  :%                           # Optional port number
  [a-z]{2,6}\b                 # Domain extension e.g: ".com"
  (?:\?[^\n\r]*)?              # Optional query string ?q=
  (?:#[^\n\r]*)?               # Optional fragment e.g: #comment

  ## Examples

      iex> Regex.run(Link.regex(), "dwyl.com") |> List.flatten |> Enum.filter(& &1 != "") |> List.first
      "dwyl.com"
  """
  def regex do
    ~r|[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,14}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)|
  end

  @doc """
  `valid?/1` confirms if a URL is valid
  using the `RFC 3986` compliant `regex/0` above.

  ## Examples

      iex> Link.valid?("example.c")
      false

      iex> Link.valid?("https://www.example.com")
      true
  """
  def valid?(url) do
    Regex.match?(regex(), url)
  end

  @doc """
  `find/1` finds all instances of a URL in a block of text.

  ## Examples

      iex> Link.find("Text with links http://goo.gl/3co4ae and https://git.io/top & www.dwyl.com etc.")
      ["http://goo.gl/3co4ae", "https://git.io/top", "www.dwyl.com"]

      # Find a link without any other text or whitespace #8
      iex> Link.find("https://github.com/dwyl/link/pull/5#pullrequestreview-1558913764")
      ["https://github.com/dwyl/link/pull/5#pullrequestreview-1558913764"]
  """
  def find(text) do
    Regex.scan(regex(), text)
    |> Enum.map(&hd/1)
    # Reject URL with 3 dots i.e. JS spread operator `...numbers`
    # Ref: github.com/dwyl/link/issues/6
    |> Enum.reject(&String.contains?(&1, "..."))
    # Avoid replacing links with lower specificity
    |> Enum.sort_by(&String.length/1, :desc)
  end

  # Add then remove the spacer to the end of any text #8
  @spacer " |fin"
  @doc """
  `find_replace_compact/1` finds all instances of a URL in a block of text
  and replaces them with the `compact/1` version.

  Only compact the links that aren't surrounded by brackets "()"
  i.e: "This is our MVP: https://mvp.fly.dev/ please try it!"
  Becomes "This is our MVP: [mvp.fly.dev](https://mvp.fly.dev/) please try it!"
  But if the text *already* has a Markdown link or an image, don't compact the URL!
  e.g: "Please try our App: [app.dwyl.com](https://app.dwyl.com/) feedback welcome!"
  No change required because it's *already* hyperlinked.

  ## Examples

      iex> md = "# Hello World! https://github.com/dwyl/mvp/issues/141#issuecomment-1657954420 and https://mvp.fly.dev/ "
      iex> Link.find_replace_compact(md)
      "# Hello World! [dwyl/mvp#141](https://github.com/dwyl/mvp/issues/141#issuecomment-1657954420) and [mvp.fly.dev](https://mvp.fly.dev/) "

      # Does not attempt to compact an existing markdown [link](https://github.com/dwyl/link) or ![image](https://imgur.com/gallery/odNLFdO)
      iex> md = "existing markdown [link](https://github.com/dwyl/link) or ![image](https://imgur.com/gallery/odNLFdO)"
      iex> Link.find_replace_compact(md)
      "existing markdown [link](https://github.com/dwyl/link) or ![image](https://imgur.com/gallery/odNLFdO)"

      iex> Link.find_replace_compact("https://github.com/dwyl/link/pull/5#pullrequestreview-1558913764")
      iex> "[dwyl/link/PR#5](https://github.com/dwyl/link/pull/5#pullrequestreview-1558913764)"
  """
  def find_replace_compact(text) do
    # Spacer added as workaround for #8
    text = text <> @spacer
    |> dbg()
    find(text)
    |> dbg()
    |> Enum.reduce(text, fn link, str ->
      # Find the Link's position in the original text:
      # stackoverflow.com/questions/35551072/find-index-of-a-substring
      {pos, len} = :binary.match(text, link)
      # Get character immediately after the link in the text:
      char = String.at(text, pos + len)
      # IO.inspect("#{text} -> #{link} -> #{char}")
      # Only replace links that have whitespace or forward slash at the end:
      if char == "\n" || char == "\r" || char == "\s" || char == "/" do
        # Create markdown link preserving the whitespace char:
        md_link = "[#{compact(link)}](#{link})#{char}"
        # Replace instance of link with char in str (text)
        String.replace(str, link <> char, md_link)
      else
        str
      end
      |> String.split(@spacer) |> List.first()
    end)
  end
end

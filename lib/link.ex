defmodule Link do
  @moduledoc """
  `Link` is a little link parsing, compacting and shortening library.
  """

  @doc """
  `compact/1` reduces a url

  ## Examples

      iex> Link.compact("https://github.com/dwyl/mvp/issues/141")
      "dwyl/mvp#141"

      # Can't understand the URL, just return it unmodified:
      iex> Link.compact("https://git.io/top")
      "https://git.io/top"

  """
  def compact(url) do
    cond do
      String.contains?(url, "github") ->
        compact_github_url(url)

      true ->
        url
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


  """
  def compact_github_url(url) do
    # Remove any hash (#) URL params, remove "https://" and "github.com/"
    clean = String.split(url, "#")
      |> List.first()
      |> String.replace("https://", "")
      |> String.replace("github.com/", "")

    # Match issue
    if String.contains?(url, "/issues/") do
      # "dwyl/mvp/issues/141"
      parts = String.split(clean, "/")
      org = Enum.at(parts, 0)
      project = Enum.at(parts, 1)
      issue_number = Enum.at(parts, 3)

      # Assemble into the compact form:
      "#{org}/#{project}##{issue_number}"

    else
      # Orgs, People or Repos just return the path e.g: "dwyl/app" or "iteles"
      clean
    end
  end
end

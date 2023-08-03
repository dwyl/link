<div align="center">

# `link`

🔗 Parse, shorten and format links. 

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/dwyl/link/ci.yml?label=build&style=flat-square&branch=main)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/gogs/main.svg?style=flat-square)](http://codecov.io/github/dwyl/auth?branch=main)
[![Hex.pm](https://img.shields.io/hexpm/v/link?color=brightgreen&style=flat-square)](https://hex.pm/packages/link)
[![docs](https://img.shields.io/badge/docs-100%25-brightgreen?style=flat-square)](https://hexdocs.pm/link/api-reference.html) 
[![Libraries.io dependency status](https://img.shields.io/librariesio/release/hex/link?logoColor=brightgreen&style=flat-square)](https://libraries.io/hex/link)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/link/issues)
[![HitCount](http://hits.dwyl.com/dwyl/link.svg)](http://hits.dwyl.com/dwyl/link)


</div>

# Why? 🤷‍♀️

We didn't find a link parsing library 
that did _exactly_ what we needed
so we wrote one. 


# What? 

A micro library for parsing and formatting links
for use in our 
[`App`](https://github.com/dwyl/app)
(currently in the 
[`MVP`](https://github.com/dwyl/mvp/issues/141)
)


> **Note**: the code is _deliberately_ "basic".
> not at all "fancy" 
> that is intentional so that it's _understandable_ 
> by a _complete_ beginner to `Elixir`. 🔰
> Simple `code` is _maintainable_ and _extensible_ 
> without having to waste time Googling to figure it out.
> That said, if you want to help refactoring for performance,
> please 
> [open an issue](https://github.com/dwyl/link/issues).

# Who? 👤

The `link` library was created _for us by us_,
the `people` building & using the `@dwyl App`. 
Ref: 
[mvp#141](https://github.com/dwyl/mvp/issues/141)
<br />
We don't expect this to be used by anyone `else`
because it's _probably_ too specific to _our_ use case.
But if you need to parse links (`URLs`) in your project
`link` can help you! 
Checkout the 
[`API Reference`](https://hexdocs.pm/link/api-reference.html).

## Feedback 💬

_Any_ feedback is very welcome. 
If you need a _specific_ feature,
please open an 
[issue](https://github.com/dwyl/link/issues)

<br />

# How? 👩‍💻

Use this package in your `Elixir` / `Phoenix` App!

## Installation ⬇️

Add `link` to your list of dependencies 
in your `mix.exs` file:

```elixir
def deps do
  [
    {:link, "~> 1.0.4"}
  ]
end
```

Complete Docs:
[hexdocs.pm/link](https://hexdocs.pm/link/Link.html#content)


## Usage Examples 🔗 

Here are a few examples we use in our `MVP`:

```elixir
# Compact a GitHub issue URL so it doesn't waste screen space:
Link.compact("https://github.com/dwyl/mvp/issues/141")
> "dwyl/mvp#141"

# Strip the #issuecomment... from a GitHub issue URL:
Link.compact("https://github.com/dwyl/mvp/issues/141#issuecomment-1636209664")
> "dwyl/mvp#141"

# Find all RFC 3986 URLs in a String or block of text:
Link.find("My text with links http://goo.gl/3co4ae and https://git.io/top and www.dwyl.com etc.")
> ["http://goo.gl/3co4ae", "https://git.io/top", "www.dwyl.com"]

# Shorten the link using Linky (interface TBD)
Link.shorten(conn, "https://github.com/dwyl/mvp/issues/141")
> "dwy.is/mvp-141"

# Confirm if a Link (URL) is valid
Link.valid?("example")
> false
Link.valid?("https://example.com")
> true

# Find all instances of a URL in a block of text
# and replaces them with the "compact" version.
md = "# Hello World! https://github.com/dwyl/mvp/issues/141#issuecomment-1657954420 and https://mvp.fly.dev/"
Link.find_replace_compact(md)
"# Hello World! [dwyl/mvp#141](https://github.com/dwyl/mvp/issues/141#issuecomment-1657954420) and [mvp.fly.dev](https://mvp.fly.dev/)"
```


# Contributing 🙏

The easiest way to contribute 
is to help us extend the 
[`test/sample_urls.csv`]()
file with more valid and _invalid_ URLs. 📝


# Need _More_? 🙌

If you need a _specific_ function,
please 
[open an issue](https://github.com/dwyl/link/issues)
to discuss. 

# Research 🔍

If you're curious about URL RegEx, read: 
[mathiasbynens.be/demo/url-regex](https://mathiasbynens.be/demo/url-regex)

According to 
[jasontucker.blog/8945/what-is-the-longest-tld](https://jasontucker.blog/8945/what-is-the-longest-tld-you-can-get-for-a-domain-name)
The longest TLD you can get in 2023 is `cancerresearch`.
Someone thought it was a good idea 
to have `labname.cancerresearch` as their domain ... 
a 14-letter TLD ... 🙄 
But there are other 13-letter TLDs such as `INTERNATIONAL` ...
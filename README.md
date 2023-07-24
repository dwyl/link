# `link`

🔗 Parse, shorten and format links. 

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

This library was created _for us by us_,
the `people` using the `@dwyl App`. <br />
We don't expect this to be used by anyone `else`
because it's _probably_ too specific to our use case.
But if you need to parse links (`URLs`) in your project
it _might_ be useful ...
If you need a _specific_ feature,
please open an 
[issue](https://github.com/dwyl/link/issues)


# How?

Use this package in your `Elixir` / `Phoenix` App!

## Installation

Add `link` to your list of dependencies 
in your `mix.exs` file:

```elixir
def deps do
  [
    {:link, "~> 1.0.0"}
  ]
end
```

Docs can be found at 
[hexdocs.pm/link](https://hexdocs.pm/link)


## Usage Examples 🔗 

Here are a few examples we use in our `MVP`:

```elixir
# Compact a GitHub issue URL so it doesn't waste screen space:
Link.compact("https://github.com/dwyl/mvp/issues/141")
> "dwyl/mvp#141"

# Strip the #issuecomment... from a GitHub issue URL:
Link.compact("https://github.com/dwyl/mvp/issues/141#issuecomment-1636209664")
> "dwyl/mvp#141"

# Shorten the link using Linky (interface TBD)
Link.shorten(conn, "https://github.com/dwyl/mvp/issues/141")
> "dwy.is/mvp-141
```

# Need _More_? 🙌

If you need a _specific_ function,
please 
[open an issue](https://github.com/dwyl/link/issues)
to discuss. 
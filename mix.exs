defmodule FireSale.Mixfile do
  use Mix.Project

  def project do
    [app: :fire_sale,
     version: "0.0.1",
     elixir: "~> 1.3.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {FireSale, []},
     applications: applications(Mix.env)]
  end

  defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_) do
    [:phoenix, :phoenix_html, :cowboy, :logger, :phoenix_ecto, :postgrex, :bamboo]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
     {:phoenix, "~> 1.2"},
     {:phoenix_ecto, "~> 3.2"},
     {:postgrex, "~> 0.0"},
     {:phoenix_html, "~> 2.1"},
     {:phoenix_haml, "~> 0.2"},
     {:guardian, "~> 0.13.0"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:comeonin, "~> 2.4"},
     {:cowboy, "~> 1.0"},
     {:httpotion, "~> 3.0.2"},
     {:remix, "~> 0.0.1", only: :dev},
     {:bamboo, "~> 0.8"}
   ]
  end
end

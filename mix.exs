defmodule ExkiqDemo.Mixfile do
  use Mix.Project

  def project do
    [app: :exkiq_demo,
     version: "0.0.1",
     elixir: "~> 0.13.2-dev",
     deps: deps]
  end

  def application do
    [ applications: [],
      mod: {ExkiqDemo, []} ]
  end

  defp deps do
    [
      { :exredis, github: "artemeff/exredis" },
      { :json,   github: "cblage/elixir-json"}
    ]
  end
end

defmodule Propertesting.MixProject do
  use Mix.Project

  def project do
    [
      app: :propertesting,
      version: "0.1.0",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Propertesting.Application, []}
    ]
  end

  defp deps do
    [
      {:stream_data, "~> 0.4.2"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end

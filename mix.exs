defmodule Exred.Node.Rpiphoto.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exred_node_rpiphoto,
      version: "0.1.6",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end
  
  defp aliases do
    [
      test: "test --no-start"
    ]
  end
  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:exred_library, "~> 0.1.11"},
      {:ex_doc, "~> 0.18.0", only: :dev, runtime: false},
      {:porcelain, "~> 2.0"}
    ]
  end
  
  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Zsolt Keszthelyi"],
      links: %{
        "GitHub" => "https://github.com/exredorg/exred_node_rpiphoto",
        "Exred" => "http://exred.org"
      },
      files: ["lib", "mix.exs", "README.md", "LICENSE"]
    }
  end
end

defmodule BlogApi.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: [
        ignore_warnings: ".dialyzer-ignore.exs"
      ],
      # Docs
      name: "blog_api",
      source_url: "https://github.com/yashin5/blog_api",
      # homepage_url: "project_home_url",
      docs: [
        # The main page in the docs
        main: "blog_api",
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:test], runtime: false},
      {:earmark, "~> 1.2", only: [:dev, :test]},
      {:ex_doc, "~> 0.23", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      test: ["test"],
      setup: ["deps.get", "deps.compile", "ecto.create", "ecto.migrate"],
      reset: ["ecto.drop", "ecto.create", "ecto.migrate"]
    ]
  end
end

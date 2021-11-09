defmodule Project1.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "app",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dializer: [
        plt_add_deps: :app_direct
      ]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
    ]
  end
end

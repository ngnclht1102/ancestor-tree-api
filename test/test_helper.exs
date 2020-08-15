{:ok, _} = Application.ensure_all_started(:ex_machina)

Bureaucrat.start(
  writer: Bureaucrat.MarkdownWriter,
  default_path: "docs/index.md",
  paths: [],
  titles: [],
  env_var: "DOC",
  json_library: Jason
)

ExUnit.start(formatters: [ExUnit.CLIFormatter, Bureaucrat.Formatter])
Faker.start()
Ecto.Adapters.SQL.Sandbox.mode(App.Repo, :manual)

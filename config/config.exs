import Config

config :backend,
  greeting: "Hello"

# так как у нас был файл config ещё до создания ecto, то в него нужно добавить
# такой конфиг, если бы этого файла ранее не было, то конфиг сам бы создался
config :backend, Jotter.Repo,
  database: "backend_db",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

# так же указываем что у ecto есть репозиторий
config :backend, ecto_repos: [Jotter.Repo]

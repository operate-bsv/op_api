defmodule OpApi.Settings do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias OpApi.Repo

  @primary_key {:key, :string, []}
  schema "settings" do
    field :value, :string
  end

  @doc false
  def changeset(settings, attrs) do
    settings
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end


  @doc """
  TODO
  """
  def get(key) do
    case Repo.get(__MODULE__, key) do
      %__MODULE__{} = settings -> settings.value
      _ -> nil
    end
  end

  @doc """
  TODO
  """
  def set(key, value) do
    changeset(%__MODULE__{}, %{
      key: key,
      value: to_string(value)
    })
    |> Repo.insert(on_conflict: {:replace, [:value]}, conflict_target: :key)
  end
end

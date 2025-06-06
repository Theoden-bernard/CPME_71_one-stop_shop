defmodule ServiceDesk.Accounts.Pin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pins" do
    field :puid, :integer
    field :pin, :integer
    belongs_to :user, ServiceDesk.Accounts.User

    timestamps()
  end

  def changeset(pin, attrs) do
    pin
    |> cast(attrs, [:puid, :pin])
    |> validate_required(:puid, :pin)
    |> validate_number(:pin, less_than: 999999)
  end
end

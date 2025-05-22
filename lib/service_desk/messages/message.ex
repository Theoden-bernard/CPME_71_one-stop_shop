defmodule ServiceDesk.Messages.Message do
    use Ecto.Schema
    import Ecto.Changeset
  
    schema "messages" do
        field :message, :string
        timestamps(type: :utc_datetime)
        
        belongs_to :user, ServiceDesk.Accounts.User
    end

    def changeset(message, attrs) do
        message
        |> cast(attrs, [:message])
        |> validate_required([:message])
    end
end
defmodule ServiceDesk.Messages do
    import Ecto.Query, warn: false
    alias ServiceDesk.{Accounts, Repo}
    alias ServiceDesk.Messages.Message
    alias Ecto.Changeset

    def get_message!(id), 
        do: Repo.get!(Message, id)

    def list_messages do
        Repo.all(Message)
    end

    def create_message(%{"user_id" => user_id} = attrs) when is_integer(user_id) and user_id > 0 do
        user_id
        |> Accounts.get_user!()
        |> Ecto.build_assoc(:messages, attrs)
        |> Message.changeset()
        |> Repo.insert()
    end

    def create_message(_attrs) do 
        {:error,
            %Message{}
            |> Changeset.change()
            |> Changeset.add_error(:user, "User can't be blanck")}
    end
    
    def update_message(message, attrs) do
        message
        |> Message.changeset(attrs)
        |> Repo.update()
    end

    def delete_message(message) do
        Repo.delete(message)
    end

    def new_message do
      %Message{}
    end

    def change_message(%Message{} = message, attrs \\ %{}) do
      Message.changeset(message, attrs)
    end
end

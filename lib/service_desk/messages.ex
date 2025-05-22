defmodule ServiceDesk.Messages do
    import Ecto.Query, warn: false
    alias ServiceDesk.{Accounts, Repo}
    alias ServiceDesk.Messages.Message

    def get_message!(id), do: Repo.get!(Message, id)

    def list_messages do
        
    end

    def create_message(%{"user_id" => user_id} = attrs) when is_integer(user_id) and user_id > 0 do
        user = Accounts.get_user!(user_id)
        message = Ecto.build_assoc(user, :messages, attrs)
        Repo.insert(message)
    end

    def create_message(_attrs) do
        
    end
    
    def update_message(_message, _attrs) do
        
    end

    def delete_message(_message) do
        
    end
end
alias ServiceDesk.{Accounts, Organizations, Tags}

defmodule Work do
  def maybe_add_tags(tags) when is_list(tags) do
    tags
    |> Enum.filter(&(&1 != "") or (&1 == " "))
    |> Enum.map(fn tag ->
      if is_nil(Tags.get_tag_by_name(tag)) do
	case Tags.create_tag(%{name: tag}) do
	  {:error, error} -> IO.inspect("error : #{error} [#{tag}]")
	  {:ok, info} -> {:ok, info}
	end
      end
    end)
  end

  def add_tags(organization, line) do
    Enum.map(line.tag, fn
      "" -> :ok
      " " -> :ok
      tag ->
	Tags.get_tag_by_name!(tag)
      |> Tags.add_tag_to_organization(organization)
    end)
  end

  def add_siren(line) do
    case Integer.parse(line.siren) do
      :error -> Map.put(line, :siren, 0)
      {siren, _} -> Map.put(line, :siren, siren)
    end
  end

  def maybe_split(list, char) when is_list(list),
    do: Enum.map(list, &maybe_split(&1, char))
  
  def maybe_split(string, char) do
    String.split(string, char)
    |> Enum.map(&String.trim(&1))
  end

  def clean_tag(tag) do
    tag
    |> String.replace("\n", "")
    |> Work.maybe_split(";")
    |> Work.maybe_split(",")
    |> Work.maybe_split(":")
    |> Enum.reduce([], fn
      [""], acc -> acc
      tag, acc -> [tag | acc]
    end)
    |> List.flatten()
  end
end

headers =  [:name, :addr, :address_1, :zip_code, :city, :country, :phone, :email, :baseline, :activity, :website, :linkedin, :youtube, :x, :pappers, :siren, :tva, :naf, :domaine, :couverture, :presentation, :tag, :expertise, :certifications, :addr_2, :address_1_2, :zip_code_2, :city_2, :country_2, :phone_2, :email_2, :address_1_3, :zip_code_3, :city_3, :country_3]

[_ | csv_data] = "data.csv"
|> Path.expand(__DIR__)
|> File.stream!()
|> CSV.decode([separator: ?,, encoding: {:utf16, :little}, headers: headers, escape_max_lines: 42])
|> Enum.map(fn {:ok, %{phone: phone, email: email, tag: tag} = line} ->
  line
  |> Map.put(:tag, Work.clean_tag(tag))
  |> Map.put(:password, Ecto.UUID.generate())
  |> Map.put(:email, String.trim(email))
  |> Map.put(:landline, phone)
  |> Work.add_siren()
end)

csv_data
|> Enum.reduce([], fn line, acc -> Map.get(line, :tag) ++ acc  end)
|> Work.maybe_add_tags()

 csv_data
 |> Enum.map(fn line ->
   case %Accounts.User{}
   |> Accounts.User.registration_changeset(line)
   |> ServiceDesk.Repo.insert() do
     {:error, _} ->
       Accounts.get_user_by_email(line.email)
     {:ok, user} -> user
   end
   |> Organizations.create_organization(line)
   |> elem(1)
   |> Work.add_tags(line)
 end)

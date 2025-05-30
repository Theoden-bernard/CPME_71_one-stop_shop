defmodule ServiceDeskWeb.Live.TagLive.Index do
    use ServiceDeskWeb, :live_view
    alias ServiceDesk.Tags

    def mount(_, _, socket) do
        tags_list = Tags.list_tags()
        {:ok, assign(socket, :tags_list, tags_list)}
    end
end
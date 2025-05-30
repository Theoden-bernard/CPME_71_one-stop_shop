defmodule ServiceDeskWeb.Live.ZoneLive.Index do
    use ServiceDeskWeb, :live_view
    alias ServiceDesk.Zones

    def mount(_, _, socket) do
        zone_list = Zones.list_zones()
        {:ok, assign(socket, :zones_list, zone_list)}
    end
end
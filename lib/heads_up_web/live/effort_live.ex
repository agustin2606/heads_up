defmodule HeadsUpWeb.EffortLive do
  use HeadsUpWeb, :live_view

  def mount(_params, _session, socket) do
    IO.inspect(self(), label: "MOUNT")

    if connected?(socket) do
      Process.send_after(self(), :tick, 2000)
    end

    socket = assign(socket, page_title: "Effort", number_responders: 10, average_minutes: 10)

    {:ok, socket}
  end

  def handle_event("add", %{"quantity" => quantity}, socket) do
    IO.inspect(self(), label: "HANDLE_EVENT")

    socket = update(socket, :number_responders, &(&1 + String.to_integer(quantity)))

    {:noreply, socket}
  end

  def handle_event("recalculate", %{"minutes" => minutes}, socket) do
    socket = assign(socket, :average_minutes, String.to_integer(minutes))

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 2000)

    {:noreply, update(socket, :number_responders, &(&1 + 3))}
  end
end

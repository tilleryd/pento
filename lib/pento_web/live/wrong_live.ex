defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def mount(_params, session, socket) do
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Make a guess:",
        time: time(),
        correct: Enum.random(1..10),
        session_id: session["live_socket_id"]
      )
    }
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>Your guess is: <%= @message %></h2>
    <h2>It's <%= @time %></h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number={n} ><%= n %></a>
      <% end %>
      <pre>
        <%= @current_user.email %>
        <%= @session_id %>
      </pre>
    </h2>
    """
  end

  def time() do
    DateTime.utc_now |> to_string
  end

  # function that changes the live view's state based on the inbound event
  def handle_event("guess", %{"number" => guess}=_data, socket) do

    {message, score} = cond do
      "#{guess}" == "#{socket.assigns.correct}" -> {"#{guess}. Correct. Good job!", socket.assigns.score + 1}
      "#{guess}" !== "#{socket.assigns.correct}" -> {"#{guess}. Wrong. Guess again.", socket.assigns.score - 1}
    end

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        time: time()
      )
    }
  end
end

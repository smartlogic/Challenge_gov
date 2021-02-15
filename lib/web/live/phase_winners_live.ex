defmodule Web.PhaseWinnersLive do
  use Phoenix.LiveView, layout: {Web.LayoutView, "live.html"}

  alias ChallengeGov.Phases
  alias ChallengeGov.Challenges.Phases.Winner

  import Phoenix.LiveView.Helpers

  def render(assigns) do
    Phoenix.View.render(Web.PhaseView, "winners.html", assigns)
  end

  def mount(p, s, socket) do
    {:ok, challenge} = ChallengeGov.Challenges.get(p["cid"])
    {:ok, phase} = ChallengeGov.Phases.get(p["pid"])
    changeset = Winner.changeset(%Winner{}, %{})

    socket =
      socket
      |> assign(:phase, phase)
      |> assign(:challenge, challenge)
      |> assign(:changeset, changeset)
      |> assign(:winner_form, false)
      |> assign(:uploaded_files, [])
      |> Phoenix.LiveView.allow_upload(:winner_image_extension, accept: ~w(.jpg .jpeg .png))
    {:ok, socket}
  end

  def handle_event("add-winner", params, socket) do
    socket =
      socket
      |> assign(:winner_form, true)
    {:noreply, socket}
  end

  def handle_event("save", params, socket) do
    {:noreply, socket}
  end

  def handle_event("submit", params, socket) do
    #  to: Routes.challenge_phase_winner_path(Web.Endpoint, :winners_published, @challenge.id, @phase.id),
    Phases.create_winner(params)
    
    {:noreply, socket}
  end
end
defmodule IdeaPortal.Challenges do
  @moduledoc """
  Context for Challenges
  """

  alias IdeaPortal.Challenges.Challenge
  alias IdeaPortal.Repo

  @doc false
  def focus_areas(), do: Challenge.focus_areas()

  @doc """
  New changeset for a challenge
  """
  def new(user) do
    user
    |> Ecto.build_assoc(:challenges)
    |> Challenge.create_changeset(%{})
  end

  @doc """
  Submit a new challenge for a user
  """
  def submit(user, params) do
    user
    |> Ecto.build_assoc(:challenges)
    |> Challenge.create_changeset(params)
    |> Repo.insert()
  end
end
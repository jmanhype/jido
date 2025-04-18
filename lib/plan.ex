defmodule Plan do
  @moduledoc """
  Creates a direct plan for a goal.
  """

  @doc "Generate the most direct plan for a goal."
  @spec direct(Goal.t(), map()) :: %{steps: [any()]}
  def direct(goal, _context) do
    %{steps: goal.params[:steps] || []}
  end

  @doc "Replan if the environment changes."
  @spec replan(Goal.t(), map()) :: %{steps: [any()]}
  def replan(goal, context), do: direct(goal, context)
end

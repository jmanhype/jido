defmodule GoalManager do
  @moduledoc """
  Manages the agent's goals.
  """
  alias Goal

  defstruct goals: []
  @type t :: %__MODULE__{goals: [Goal.t()]}

  @doc "Add a new goal and sort by priority."
  @spec add_goal(t(), Goal.t()) :: t()
  def add_goal(%__MODULE__{goals: goals} = state, goal) do
    %{state | goals: [goal | goals] |> Enum.sort_by(& &1.priority, :desc)}
  end

  @doc "Get the next pending goal."
  @spec next_goal(t()) :: Goal.t() | nil
  def next_goal(%__MODULE__{goals: goals}) do
    Enum.find(goals, &(&1.status == :pending))
  end

  @doc "Mark a goal as completed."
  @spec complete_goal(t(), String.t()) :: t()
  def complete_goal(%__MODULE__{goals: goals} = state, goal_id) do
    updated = Enum.map(goals, fn
      %Goal{id: ^goal_id} = g -> %{g | status: :completed}
      g -> g
    end)
    %{state | goals: updated}
  end
end

defmodule Jido.Agent.GoalAgent do
  @moduledoc """
  Example goal-driven agent using the GoalDrivenMetaAction.
  """

  use Jido.Agent,
    name: "goal_agent",
    schema: [
      goals:  [type: {:list, :any}, default: []],
      status: [type: :atom,      default: :pending]
    ],
    actions: [Jido.Actions.GoalDrivenMetaAction]

  @impl true
  def on_before_plan(agent, _action, _params) do
    # Mark urgent if any goal.priority > 50
    new_status =
      if Enum.any?(agent.state.goals, &(&1[:priority] > 50)), do: :urgent, else: :normal

    {:ok, %{agent | state: %{agent.state | status: new_status}}}
  end
end

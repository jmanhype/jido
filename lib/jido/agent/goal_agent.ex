defmodule Jido.Agent.GoalAgent do
  @moduledoc """
  An example Jido agent that demonstrates adaptive, goal-driven planning using GoalDrivenMetaAction.
  """

  use Jido.Agent,
    name: "goal_agent",
    description: "An agent that adapts its action plan based on goals.",
    category: "goal_driven",
    tags: ["goal", "adaptive", "meta-action"],
    vsn: "0.1.0",
    schema: [
      goals: [type: {:list, :any}, default: []],
      status: [type: :atom, default: :pending],
      result: [type: :any]
    ],
    actions: [Jido.Actions.GoalDrivenMetaAction, Jido.Action, Jido.Action]
    # Replace Jido.Action with your domain-specific actions

  @doc """
  Adaptive planner callback: prioritizes actions based on goals before planning.
  """
  @impl true
  def on_before_plan(agent, _action, _params) do
    # Example: prioritize actions if urgent goals present
    urgent_goals = Enum.filter(agent.state.goals, fn g -> g[:priority] == :high end)
    agent =
      if urgent_goals != [] do
        %{agent | state: Map.put(agent.state, :status, :running)}
      else
        agent
      end
    {:ok, agent}
  end
end

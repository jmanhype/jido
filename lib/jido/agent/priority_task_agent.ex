defmodule Jido.Agent.PriorityTaskAgent do
  @moduledoc """
  Example agent that orders goals by descending priority before planning.

  Goals must include a `:priority` key (integer). Higher values run first.
  """

  use Jido.Agent,
    name: "priority_task_agent",
    schema: [
      goals: [type: {:list, :any}, default: []]
    ],
    actions: [
      Jido.Actions.GoalDrivenMetaAction,
      Jido.Agent.PriorityTaskAgent.SendEmail,
      Jido.Agent.PriorityTaskAgent.GenerateReport
    ]

  @impl true
  def on_before_plan(agent, _action, _params) do
    sorted = Enum.sort_by(agent.state.goals, & &1[:priority], :desc)
    new_state = %{agent.state | goals: sorted}
    {:ok, %{agent | state: new_state}}
  end
end

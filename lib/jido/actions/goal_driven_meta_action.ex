defmodule Jido.Actions.GoalDrivenMetaAction do
  @moduledoc """
  A meta-action for Jido agents that dynamically selects and enqueues actions based on agent goals and state.

  This action enables hierarchical, goal-driven reasoning within the Jido action framework.
  """

  @behaviour Jido.Action

  require Logger

  @impl true
  def run(agent, _params \\ %{}) do
    goals = Map.get(agent.state, :goals, [])
    actions = select_actions_from_goals(goals, agent)

    Logger.info("[GoalDrivenMetaAction] Selected actions: #{inspect(actions)} for goals: #{inspect(goals)}")

    # Enqueue actions dynamically (prepend to pending_instructions)
    updated_agent = enqueue_actions(agent, actions)
    {:ok, updated_agent}
  end

  defp select_actions_from_goals([], _agent), do: []
  defp select_actions_from_goals(goals, _agent) do
    # Example: Map goals to actions (customize as needed)
    Enum.flat_map(goals, fn goal ->
      case goal do
        %{type: :process, action: action_mod, params: action_params} ->
          [{action_mod, action_params}]
        _ ->
          []
      end
    end)
  end

  defp enqueue_actions(agent, actions) do
    Enum.reduce(actions, agent, fn {mod, params}, ag ->
      if function_exported?(Jido.Agent, :plan, 3) do
        Jido.Agent.plan(ag, mod, params)
        |> case do
          {:ok, new_ag} -> new_ag
          {:error, _} -> ag
        end
      else
        ag
      end
    end)
  end

  # Stub required callbacks for Jido.Action behaviour
  def on_after_run(_agent), do: :ok
  def on_after_validate_params(_params), do: :ok
  def on_before_validate_params(_params), do: :ok
  def on_error(_agent, _params, _reason, _context), do: {:error, :not_implemented}

end

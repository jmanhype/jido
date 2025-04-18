defmodule Jido.Actions.GoalDrivenMetaAction do
  @moduledoc """
  Meta-action that selects and enqueues actions based on agent goals.
  """

  @behaviour Jido.Action

  alias Jido.Agent.Directive.Enqueue

  @impl true
  def run(params, %{state: state}) do
    goals = Map.get(params, :goals, state.goals)
    actions = select_actions_from_goals(goals)

    directives =
      Enum.map(actions, fn {mod, ps} ->
        %Enqueue{action: mod, params: ps, context: %{}, opts: []}
      end)

    {:ok, %{}, directives}
  end

  @impl true
  def on_before_validate_params(params), do: {:ok, params}

  @impl true
  def on_after_validate_params(params), do: {:ok, params}

  @impl true
  def on_after_run(agent), do: {:ok, agent}

  @impl true
  def on_error(agent, _params, reason, _context), do: {:error, reason}

  defp select_actions_from_goals(goals) do
    Enum.map(goals, fn
      %{action: action, params: params} -> {action, params}
      other -> raise ArgumentError, "invalid goal format: #{inspect(other)}"
    end)
  end
end

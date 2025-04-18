defmodule Jido.Agent.PriorityTaskAgent.GenerateReport do
  @moduledoc """
  Demo action: Pretends to generate a report and updates the agent's result.
  """
  @behaviour Jido.Action

  @impl true
  @spec run(params :: map, context :: map) :: {:ok, map, list} | {:error, any}
  def run(_params, context) do
    result = Map.get(context, :result, %{})
    merged_result = Map.merge(result, %{report_generated: true})
    new_context = Map.put(context, :result, merged_result)
    {:ok, new_context, []}
  end

  @impl true
  @spec validate_params(map) :: {:ok, map}
  def validate_params(params), do: {:ok, params}

  @impl true
  @spec on_after_run(struct) :: {:ok, struct}
  def on_after_run(agent), do: {:ok, agent}

  @doc """
  Returns metadata for the GenerateReport action.
  """
  @spec __action_metadata__() :: map
  def __action_metadata__, do: %{
    name: "generate_report",
    description: "Simulates generating a report.",
    params: %{}
  }

  @impl true
  @spec on_before_validate_params(struct) :: {:ok, struct}
  def on_before_validate_params(agent), do: {:ok, agent}

  @impl true
  @spec on_after_validate_params(struct) :: {:ok, struct}
  def on_after_validate_params(agent), do: {:ok, agent}

  @impl true
  @spec on_error(struct, map, any, map) :: {:error, any}
  def on_error(agent, _params, reason, _context), do: {:error, reason}
end

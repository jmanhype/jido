defmodule AgentExecutor do
  @moduledoc """
  Executes goals efficiently and adapts to environment changes.
  """
  alias Plan
  alias Step
  alias Environment

  @spec execute(Goal.t(), map()) :: map()
  def execute(goal, context) do
    plan = Plan.direct(goal, context)

    Enum.reduce_while(plan.steps, context, fn step, ctx ->
      if Environment.threat_detected?(ctx) do
        {:halt, Map.put(ctx, :error, :threat_detected)}
      else
        if Step.necessary?(step, ctx) do
          case Step.execute(step, ctx) do
            {:ok, new_ctx} ->
              if Environment.changed?(new_ctx) do
                {:halt, Plan.replan(goal, new_ctx)}
              else
                {:cont, new_ctx}
              end
            {:error, reason} ->
              {:halt, Map.put(ctx, :error, reason)}
          end
        else
          {:cont, ctx}
        end
      end
    end)
  end
end

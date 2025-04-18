defmodule Step do
  @moduledoc """
  Represents an executable step in a plan.
  """

  @doc "Determine if a step is necessary given the current context."
  @spec necessary?(any(), map()) :: boolean()
  def necessary?(_step, _context), do: true

  @doc "Execute a step."
  @spec execute(any(), map()) :: {:ok, map()} | {:error, term()}
  def execute(step, context), do: {:ok, Map.put(context, :last_step, step)}
end

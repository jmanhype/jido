defmodule Goal do
  @moduledoc """
  Represents a task or objective for the agent.
  """
  @enforce_keys [:id, :description, :priority, :status, :params]
  defstruct [:id, :description, :priority, :status, :params]

  @type t :: %__MODULE__{
          id: String.t(),
          description: String.t(),
          priority: integer(),
          status: :pending | :active | :completed | :failed,
          params: map()
        }
end

defmodule Environment do
  @moduledoc """
  Provides information about the current environment.
  """

  @doc "Detect if there are any threats or issues."
  @spec threat_detected?(map()) :: boolean()
  def threat_detected?(_context), do: false

  @doc "Detect if the environment has changed in a way that requires replanning."
  @spec changed?(map()) :: boolean()
  def changed?(_context), do: false
end

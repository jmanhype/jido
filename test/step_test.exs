defmodule StepTest do
  """
  Tests for the Step module.
  """
  use ExUnit.Case

  @moduletag :step

  test "necessary? always returns true by default" do
    assert Step.necessary?(:any, %{}) == true
  end

  test "execute adds last_step to context" do
    context = %{}
    {:ok, result} = Step.execute(:step1, context)
    assert result[:last_step] == :step1
  end
end

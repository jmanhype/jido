defmodule Jido.Actions.GoalDrivenMetaActionTest do
  use ExUnit.Case, async: true

  alias Jido.Actions.GoalDrivenMetaAction
  alias Jido.Agent.Directive.Enqueue

  defmodule DummyAction do
  end

  test "run emits enqueue directives based on goals" do
    goals = [%{action: DummyAction, params: %{foo: :bar}}]
    agent_wrapper = %{state: %{goals: goals}}

    {:ok, new_state, directives} =
      GoalDrivenMetaAction.run(%{}, agent_wrapper)

    assert new_state == %{}
    assert [%Enqueue{action: DummyAction, params: %{foo: :bar}}] = directives
  end

  test "invalid goal format raises ArgumentError" do
    goals = [:invalid]
    agent_wrapper = %{state: %{goals: goals}}

    assert_raise ArgumentError, ~r/invalid goal format/, fn ->
      GoalDrivenMetaAction.run(%{}, agent_wrapper)
    end
  end
end

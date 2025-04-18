defmodule Jido.Agent.GoalAgentTest do
  @moduledoc """
  Tests for the GoalAgent demonstrating goal-driven meta-action and adaptive planning.
  """
  use ExUnit.Case
  alias Jido.Agent.GoalAgent

  test "GoalAgent enqueues actions based on goals" do
    agent = GoalAgent.new()
    goals = [
      %{type: :process, action: Jido.Action, params: %{value: 42}, priority: :high},
      %{type: :process, action: Jido.Action, params: %{value: 7}, priority: :low}
    ]
    {:ok, agent} = GoalAgent.set(agent, goals: goals)
    {:ok, agent} = GoalAgent.plan(agent, Jido.Actions.GoalDrivenMetaAction, %{})
    actions = GoalAgent.registered_actions(agent)
    assert Jido.Action in actions
    assert agent.state.goals == goals
  end

  test "GoalAgent updates status for urgent goals" do
    agent = GoalAgent.new()
    goals = [%{type: :process, action: Jido.Action, params: %{}, priority: :high}]
    {:ok, agent} = GoalAgent.set(agent, goals: goals)
    {:ok, agent} = GoalAgent.plan(agent, Jido.Actions.GoalDrivenMetaAction, %{})
    assert agent.state.status == :running
  end
end

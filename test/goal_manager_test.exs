defmodule GoalManagerTest do
  """
  Tests for the GoalManager module.
  """
  use ExUnit.Case
  alias Goal
  alias GoalManager

  @moduletag :goal_manager

  test "add and retrieve goals by priority" do
    goal1 = %Goal{id: "g1", description: "First", priority: 1, status: :pending, params: %{}}
    goal2 = %Goal{id: "g2", description: "Second", priority: 2, status: :pending, params: %{}}
    manager = %GoalManager{}
    manager = GoalManager.add_goal(manager, goal1)
    manager = GoalManager.add_goal(manager, goal2)
    assert Enum.map(manager.goals, & &1.id) == ["g2", "g1"]
  end

  test "next_goal returns the highest priority pending goal" do
    goal1 = %Goal{id: "g1", description: "First", priority: 1, status: :completed, params: %{}}
    goal2 = %Goal{id: "g2", description: "Second", priority: 2, status: :pending, params: %{}}
    manager = %GoalManager{goals: [goal1, goal2]}
    assert GoalManager.next_goal(manager).id == "g2"
  end

  test "complete_goal updates goal status" do
    goal1 = %Goal{id: "g1", description: "First", priority: 1, status: :pending, params: %{}}
    manager = %GoalManager{goals: [goal1]}
    manager = GoalManager.complete_goal(manager, "g1")
    assert Enum.at(manager.goals, 0).status == :completed
  end
end

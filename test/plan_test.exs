defmodule PlanTest do
  """
  Tests for the Plan module.
  """
  use ExUnit.Case
  alias Goal
  alias Plan

  @moduletag :plan

  test "direct returns steps from goal params" do
    goal = %Goal{id: "g1", description: "desc", priority: 1, status: :pending, params: %{steps: [:a, :b]}}
    context = %{}
    plan = Plan.direct(goal, context)
    assert plan.steps == [:a, :b]
  end

  test "replan returns same as direct by default" do
    goal = %Goal{id: "g1", description: "desc", priority: 1, status: :pending, params: %{steps: [:x]}}
    context = %{}
    plan = Plan.replan(goal, context)
    assert plan.steps == [:x]
  end
end

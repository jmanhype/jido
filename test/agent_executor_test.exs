defmodule AgentExecutorTest do
  """
  Tests for the AgentExecutor module.
  """
  use ExUnit.Case
  import AgentExecutor

  alias Goal
  alias GoalManager

  @moduletag :agent_executor

  test "executes a simple goal with steps" do
    goal = %Goal{
      id: "test_goal",
      description: "A test goal",
      priority: 1,
      status: :pending,
      params: %{steps: [:step1, :step2]}
    }
    context = %{}
    result = AgentExecutor.execute(goal, context)
    assert result[:last_step] == :step2
  end

  test "handles unnecessary steps" do
    defmodule Step do
      def necessary?(step, _ctx), do: step == :needed
      def execute(step, ctx), do: {:ok, Map.put(ctx, :last_step, step)}
    end
    goal = %Goal{
      id: "goal2",
      description: "Goal with unnecessary step",
      priority: 1,
      status: :pending,
      params: %{steps: [:needed, :skip]}
    }
    context = %{}
    result = AgentExecutor.execute(goal, context)
    assert result[:last_step] == :needed
  end

  test "handles threat detection" do
    defmodule Environment do
      def threat_detected?(_ctx), do: true
      def changed?(_ctx), do: false
    end
    goal = %Goal{
      id: "goal3",
      description: "Goal with threat",
      priority: 1,
      status: :pending,
      params: %{steps: [:step1]}
    }
    context = %{}
    result = AgentExecutor.execute(goal, context)
    assert result[:error] == :threat_detected
  end

  test "handles environment change and replans" do
    defmodule Environment do
      def threat_detected?(_ctx), do: false
      def changed?(_ctx), do: true
    end
    goal = %Goal{
      id: "goal4",
      description: "Goal with env change",
      priority: 1,
      status: :pending,
      params: %{steps: [:step1]}
    }
    context = %{}
    result = AgentExecutor.execute(goal, context)
    assert is_map(result)
    # Could add more checks for replan logic
  end
end

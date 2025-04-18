# Goal-Driven Jido Agent Extension

## Overview
This extension demonstrates how to build adaptive, goal-driven agents in the Jido framework using a meta-action and adaptive planning callback.

## Key Modules
- `Jido.Actions.GoalDrivenMetaAction`: An action that selects and enqueues other actions based on agent goals.
- `Jido.Agent.GoalAgent`: Example agent using adaptive planning and meta-action.

## Usage Example
```elixir
defmodule MyGoalAgent do
  use Jido.Agent,
    name: "goal_agent",
    schema: [goals: [type: {:list, :any}, default: []]],
    actions: [Jido.Actions.GoalDrivenMetaAction, MyAction1, MyAction2]

  def on_before_plan(agent, action, params) do
    # Adapt action queue based on goals
    {:ok, agent}
  end
end
```

## Running Tests
Run with:
```
mix test test/jido/agent/goal_agent_test.exs
```

## Benefits
- **Composable**: Works with existing Jido agents/actions.
- **Extensible**: Supports advanced agent reasoning.
- **Adaptive**: Enables agents to respond to goals and context in real time.

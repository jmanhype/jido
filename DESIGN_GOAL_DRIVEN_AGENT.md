# Jido Goal-Driven Agent Extension: Design Doc

## Overview
This extension brings state-of-the-art, goal-driven reasoning to the Jido agent framework by leveraging its action-centric architecture. It introduces:
- **GoalDrivenMetaAction**: An Action that dynamically selects and executes other actions based on agent goals and state.
- **Adaptive Planner**: A planning callback that prioritizes and enqueues actions based on goals, context, or feedback.

## Architecture

### 1. Meta-Action
- **Module:** `Jido.Actions.GoalDrivenMetaAction`
- **Purpose:** When executed, it inspects agent state (e.g., a list of goals/priorities) and enqueues or invokes other actions to achieve those goals.
- **Features:**
  - Can handle hierarchical or composite goals (sub-goals as actions).
  - Supports dynamic adaptation based on agent state or environment.

### 2. Adaptive Planner
- **Callback:** `on_before_plan/3`
- **Purpose:** Customizes the agent's pending action queue at planning time, using agent state, goals, or external signals.
- **Features:**
  - Can re-prioritize, insert, or remove actions based on current context.
  - Enables agents to adapt plans at runtime.

### 3. Integration Points
- **Agent Definition:**
  - Agents register `GoalDrivenMetaAction` and any domain-specific actions.
  - Agents implement `on_before_plan/3` to inject adaptive planning logic.
- **State Schema:**
  - Extend agent state to include `goals`, `priorities`, or `context` as needed.

## Example Usage

```elixir
defmodule MyGoalAgent do
  use Jido.Agent,
    name: "goal_agent",
    schema: [goals: [type: {:list, :any}, default: []], ...],
    actions: [Jido.Actions.GoalDrivenMetaAction, MyAction1, MyAction2]

  # Adaptive planner callback
  def on_before_plan(agent, action, params) do
    # Inspect agent.state.goals and adapt action queue
    # Example: prioritize actions based on goals
    {:ok, agent}
  end
end
```

## Benefits
- **Composable:** Works with existing Jido agents and actions.
- **Extensible:** Supports advanced agent reasoning without breaking core contracts.
- **Adaptive:** Enables agents to respond to goals and context in real time.

## Next Steps
- Implement `GoalDrivenMetaAction`.
- Implement an example agent with adaptive planning.
- Add tests and documentation.
- Clean up exploratory modules and commit only the new, integrated extension.

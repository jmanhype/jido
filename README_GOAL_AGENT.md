# Jido Goal-Driven Agent Extension

This extension adds a flexible goal-driven planning layer to the Jido framework.
Agents can declare a list of goals and use a meta-action to enqueue tasks dynamically.

---
## Features

- **GoalDrivenMetaAction**: Inspects `agent.state.goals` and emits `%Enqueue{}` directives.
- **Adaptive Planner Hook**: Agents implement `on_before_plan/3` to sort or filter goals before planning.
- **Directive-First Queue**: Robust normalization of `pending_instructions` to an Erlang `:queue`.
- **Example Agents**:
  - `Jido.Agent.GoalAgent`: Basic goal-driven agent.
  - `Jido.Agent.PriorityTaskAgent`: Orders goals by descending `:priority`.

---
## Installation

Add to your mix dependencies:

```elixir
# mix.exs
defp deps do
  [
    {:jido, "~> 0.1.0"},
    {:your_goal_extension, in_umbrella: true}
  ]
end
```

Run:

```
mix deps.get
```

---
## Usage

### 1. Define Goals

Your agent state must include a `:goals` list:

```elixir
%{goals: [%{action: MyAction, params: %{foo: "bar"}}]}
```

### 2. Attach the Meta-Action

In your agent module:

```elixir
use Jido.Agent,
  name: "my_goal_agent",
  schema: [goals: [type: {:list, :any}, default: []]],
  actions: [Jido.Actions.GoalDrivenMetaAction]
```

### 3. (Optional) Customize Planning

Implement `on_before_plan/3` to modify goals:

```elixir
@impl true
def on_before_plan(agent, _action, _params) do
  sorted = Enum.sort_by(agent.state.goals, & &1[:priority], :desc)
  {:ok, %{agent | state: %{agent.state | goals: sorted}}}
end
```

### 4. Run the Agent

```elixir
{:ok, pid} = Jido.Runner.Simple.start_link(MyGoalAgent)
Jido.Runner.Simple.send(pid, :run)
```

---
## Testing

```bash
mix test
```

All existing tests (including goal-driven meta-action and journal tests) should pass.

---
## Examples

```elixir
# PriorityTaskAgent example
{:ok, pid} = Jido.Runner.Simple.start_link(Jido.Agent.PriorityTaskAgent)
state = %{goals: [
  %{action: TaskA, params: %{}, priority: 1},
  %{action: TaskB, params: %{}, priority: 5}
]}
Jido.Runner.Simple.send(pid, {:run, state})
# TaskB runs before TaskA
```

---
## License

MIT

# Goal-Driven Agent Extension Guide

This document describes the goal-driven agent feature, how to implement it in Jido, and how to avoid common pitfalls.

---

## 1. Feature Overview

- **High-Level Goals**: Agents carry a list of goal maps (`%{type, action, params, priority}`) in their state.
- **Meta-Action**: `Jido.Actions.GoalDrivenMetaAction` inspects goals, selects actions, and emits `%Enqueue{}` directives (no direct state mutation).
- **Adaptive Planning Hook**: Implement `on_before_plan/3` in your agent to sort, filter, or expand goals (e.g. priority, context).
- **Directive-First Queue**: The directive pipeline normalizes `pending_instructions` as an Erlang `:queue` before enqueueing.

---

## 2. Implementation Steps

### 2.1 Fix Directive Handler

In `lib/jido/agent/directive.ex`, update `apply_single_directive/3` for `%Enqueue{}`:
```elixir
existing     = Map.get(agent, :pending_instructions, nil)
pending_queue =
  cond do
    :queue.is_queue(existing) -> existing
    is_list(existing)         -> :queue.from_list(existing)
    true                      -> :queue.new()
  end

{:ok, %{agent | pending_instructions: :queue.in(instruction, pending_queue)}}
```

### 2.2 Create Meta-Action

Add `lib/jido/actions/goal_driven_meta_action.ex`:
```elixir
@impl true
def run(params, %{state: state}) do
  goals     = Map.get(params, :goals, state.goals)
  actions   = select_actions_from_goals(goals, state)
  directives =
    for {mod, ps} <- actions do
      %Enqueue{action: mod, params: ps, context: %{}, opts: []}
    end
  {:ok, %{}, directives}
end

# add @impl true for on_after_run/1, on_error/4, etc.
```

### 2.3 Build Adaptive Planner Agent

Create `lib/jido/agent/goal_agent.ex`:
```elixir
defmodule Jido.Agent.GoalAgent do
  use Jido.Agent,
    name: "goal_agent",
    schema: [
      goals:  [type: {:list, :any}, default: []],
      status: [type: :atom,      default: :pending]
    ],
    actions: [Jido.Actions.GoalDrivenMetaAction]

  @impl true
  def on_before_plan(agent, _action, _params) do
    status = if Enum.any?(agent.state.goals, &(&1[:priority] > 50)), do: :urgent, else: :normal
    {:ok, %{agent | state: %{agent.state | status: status}}}
  end
end
```

### 2.4 Testing & Documentation

- **Tests**: `test/jido/agent/goal_agent_test.exs`, optional `priority_task_agent_test.exs`.
- **Docs**: maintain `DESIGN_GOAL_DRIVEN_AGENT.md` for architecture, `README_GOAL_AGENT.md` for usage.

---

## 3. Avoiding Past Pitfalls

| Pitfall                          | Fix / Preventive Measure                                      |
|---------------------------------|---------------------------------------------------------------|
| KeyError on missing queue       | Normalize via `:queue.is_queue/1` + `cond`                   |
| Direct state mutation in action | Emit directives only; runner applies queue changes            |
| Invalid NimbleOptions schema    | Use allowed keys (`:type`, `:default`, `:required`, etc.)    |
| Missing @impl annotations       | Annotate all `Jido.Action` callbacks with `@impl true`       |
| Heredoc syntax errors           | Use multiline `@moduledoc` with leading newline              |
| Private API usage               | Rely only on public action/directive runner callbacks         |

---

## 4. Reproduction from Scratch

1. Clone the repo and install dependencies:
   ```bash
git clone git@github.com:yourorg/jido.git
cd jido
mix deps.get
```
2. Create a feature branch:
   ```bash
git checkout -b feat/goal-driven-extension
```
3. Add new files:
   - `lib/jido/agent/directive.ex` (handler fix)
   - `lib/jido/actions/goal_driven_meta_action.ex` (meta-action)
   - `lib/jido/agent/goal_agent.ex` (adaptive agent)
   - `test/jido/agent/goal_agent_test.exs`
4. Remove old prototypes (`lib/goal*.ex`, etc.).
5. Run tests:
   ```bash
mix test
```
6. Commit and push:
   ```bash
git add .
git commit -m "feat(goal-agent): add goal-driven meta-action & planner"
git push origin feat/goal-driven-extension
```

---

## 5. Future Extensions & Patterns

1. Passive & Proactive Goal Creators
2. Retrieval-Augmented Generation (RAG)
3. Prompt/Response Optimizer
4. Multi-Path Plan Generator
5. Reflection Patterns (self, cross, human)
6. Multi-Agent Cooperation
7. Tool/Agent Registry & Adapter
8. Agent Evaluator / Monitoring
9. Multimodal Guardrails

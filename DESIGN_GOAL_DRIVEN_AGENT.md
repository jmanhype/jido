# Design: Goal-Driven Agent Extension

This document outlines the architecture and rationale for the goal-driven subsystem in Jido.

## System Components

1. **Directive Pipeline** (`Jido.Agent.Directive`)
   - Normalizes and applies directives to agent state.
   - Introduces `Enqueue` to queue instructions robustly.

2. **GoalDrivenMetaAction** (`Jido.Actions.GoalDrivenMetaAction`)
   - Implements `Jido.Action` behavior.
   - **Strategy**: Inspects agent goals, selects action/params tuples, and emits `%Enqueue{}` directives.
   - **Callback Structure**: `run/2`, `on_before_validate_params/1`, `on_after_validate_params/1`, `on_after_run/1`, `on_error/4`.

3. **Adaptive Planner Hooks** (`TaskAgent` Modules)
   - Agents implement `on_before_plan/3` to adjust goals dynamically (e.g. sorting, filtering).
   - Example modules:
     - `GoalAgent` (priority threshold status)
     - `PriorityTaskAgent` (sort descending by `:priority`)

4. **Runner** (`Jido.Runner.Simple`)
   - Drives the lifecycle: validate → plan → execute → on_after_run.
   - Applies directives in-order via the directive pipeline.

## Key Design Decisions

- **Declarative Directives**: Meta-actions **emit** directives, avoiding direct state mutation and centralizing queue logic.
- **Queue Normalization**: `pending_instructions` always treated as an Erlang `:queue`, with lists or nil converted safely.
- **Modular Hooks**: Agents customize lifecycle via `on_before_plan`, preserving core engine simplicity.
- **Error Handling**: Callbacks annotated with `@impl true` and propagate errors clearly.

## Extensions Roadmap

- Passive & Proactive Goal Generators
- Retrieval-Augmented Generation (RAG)
- Multi-Path Planning with Cost Models
- Reflection Patterns (self, cross-agent, human-in-the-loop)
- Multi-Agent Coordination Plugins
- Monitoring & Metrics Dashboard APIs
- Schema-Based Guardrails & Rate Limiting

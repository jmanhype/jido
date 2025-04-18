# Example: Running a goal execution with the current implementation

# Make sure to run this with: iex -S mix run example_goal_run.exs

# Import or alias modules if needed
alias Goal
alias AgentExecutor

# 1. Define a goal
goal = %Goal{
  id: "write_report",
  description: "Write a project report",
  priority: 10,
  status: :pending,
  params: %{steps: [:draft, :review, :finalize]}
}

# 2. Initial context (could be any map)
context = %{}

# 3. Execute the goal
result = AgentExecutor.execute(goal, context)

IO.inspect(result, label: "Execution Result")

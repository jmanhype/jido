defmodule EnvironmentTest do
  """
  Tests for the Environment module.
  """
  use ExUnit.Case

  @moduletag :environment

  test "threat_detected? returns false by default" do
    assert Environment.threat_detected?(%{}) == false
  end

  test "changed? returns false by default" do
    assert Environment.changed?(%{}) == false
  end
end

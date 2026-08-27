require "test_helper"

class TravelStepTest < ActiveSupport::TestCase
  test "launch uses the launch formula constants" do
    step = TravelStep.launch("earth")

    assert_equal "launch", step.maneuver
    assert_equal 9.807, step.gravity
    assert_equal 0.042, step.coefficient
    assert_equal 33, step.offset
  end

  test "land uses the landing formula constants" do
    step = TravelStep.land("moon")

    assert_equal "land", step.maneuver
    assert_equal 1.62, step.gravity
    assert_equal 0.033, step.coefficient
    assert_equal 42, step.offset
  end

  test "rejects unknown maneuvers and bodies" do
    assert_raises(ArgumentError) { TravelStep.new(maneuver: "orbit", body: "earth") }
    assert_raises(ArgumentError) { TravelStep.launch("pluto") }
  end
end

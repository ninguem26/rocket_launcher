require "test_helper"

class FuelCalculatorTest < ActiveSupport::TestCase
  test "Apollo 11 mission requires 51898 kg of fuel" do
    steps = [
      TravelStep.launch("earth"),
      TravelStep.land("moon"),
      TravelStep.launch("moon"),
      TravelStep.land("earth")
    ]

    assert_equal 51898, FuelCalculator.total_fuel(equipment_mass: 28801, steps: steps)
  end

  test "Mars mission requires 33388 kg of fuel" do
    steps = [
      TravelStep.launch("earth"),
      TravelStep.land("mars"),
      TravelStep.launch("mars"),
      TravelStep.land("earth")
    ]

    assert_equal 33388, FuelCalculator.total_fuel(equipment_mass: 14606, steps: steps)
  end

  test "passenger ship mission requires 212161 kg of fuel" do
    steps = [
      TravelStep.launch("earth"),
      TravelStep.land("moon"),
      TravelStep.launch("moon"),
      TravelStep.land("mars"),
      TravelStep.launch("mars"),
      TravelStep.land("earth")
    ]

    assert_equal 212161, FuelCalculator.total_fuel(equipment_mass: 75432, steps: steps)
  end

  test "returns zero extra fuel when a maneuver formula is not positive" do
    tiny_mass = 1
    fuel = FuelCalculator.new(
      equipment_mass: tiny_mass,
      steps: [ TravelStep.land("moon") ]
    ).total_fuel

    assert_equal 0, fuel
  end

  test "counts the mass of fuel itself recursively for a single maneuver" do
    step = TravelStep.launch("earth")
    mass = 28801
    first_burn = (mass * step.gravity * step.coefficient - step.offset).floor
    recursive_total = FuelCalculator.total_fuel(equipment_mass: mass, steps: [ step ])

    assert_operator recursive_total, :>, first_burn
  end

  test "rejects non-positive equipment mass" do
    assert_raises(ArgumentError) do
      FuelCalculator.new(equipment_mass: 0, steps: [ TravelStep.launch("earth") ])
    end
  end

  test "rejects an empty travel path" do
    assert_raises(ArgumentError) do
      FuelCalculator.new(equipment_mass: 28801, steps: [])
    end
  end
end

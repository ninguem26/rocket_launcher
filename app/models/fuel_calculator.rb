class FuelCalculator
  StepBreakdown = Data.define(:step, :fuel)
  Result = Data.define(:total_fuel, :steps)

  def self.total_fuel(equipment_mass:, steps:)
    new(equipment_mass: equipment_mass, steps: steps).total_fuel
  end

  def initialize(equipment_mass:, steps:)
    @equipment_mass = Integer(equipment_mass)
    @steps = Array(steps)

    raise ArgumentError, "Equipment mass must be positive" unless @equipment_mass.positive?
    raise ArgumentError, "Travel path cannot be empty" if @steps.empty?
  end

  def total_fuel
    call.total_fuel
  end

  def call
    remaining_mass = @equipment_mass

    # Later maneuvers must be carried as mass during earlier ones, so fuel is
    # computed from the end of the path back to the start.
    chronological = @steps.reverse.map do |step|
      fuel = fuel_for(remaining_mass, step)
      remaining_mass += fuel
      StepBreakdown.new(step: step, fuel: fuel)
    end.reverse

    Result.new(total_fuel: chronological.sum(&:fuel), steps: chronological)
  end

  private

  def fuel_for(mass, step)
    additional = (mass * step.gravity * step.coefficient - step.offset).floor
    return 0 if additional <= 0

    additional + fuel_for(additional, step)
  end
end

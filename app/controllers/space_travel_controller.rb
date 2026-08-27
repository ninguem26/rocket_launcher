class SpaceTravelController < ApplicationController
  def show
  end

  def add_path_point
    @maneuver = params[:maneuver].to_s
    return head :unprocessable_entity unless TravelStep.known_maneuver?(@maneuver)

    respond_to do |format|
      format.turbo_stream
    end
  end

  def calculate
    @equipment_mass = parse_mass
    @steps = build_steps
    @error = validation_error
    @result = FuelCalculator.new(equipment_mass: @equipment_mass, steps: @steps).call unless @error

    render_calculation
  rescue ArgumentError => e
    @error = e.message
    render_calculation(status: :unprocessable_entity)
  end

  private

  def parse_mass
    raw = params[:mass].to_s.strip
    return if raw.blank?

    Integer(raw, exception: false)
  end

  def build_steps
    path_point_params.filter_map do |point|
      next if point[:maneuver].blank? && point[:body].blank?

      TravelStep.new(maneuver: point[:maneuver], body: point[:body])
    end
  end

  def path_point_params
    raw = params[:path_points]
    return [] if raw.blank?

    list = raw.is_a?(Array) ? raw : raw.to_unsafe_h.values

    list.map do |point|
      attributes = point.respond_to?(:permit) ? point.permit(:maneuver, :body) : point
      attributes.to_h.with_indifferent_access.slice(:maneuver, :body)
    end
  end

  def validation_error
    return "Enter a positive equipment mass in kilograms." unless @equipment_mass&.positive?
    return "Add at least one launch or landing to the travel path." if @steps.empty?

    nil
  end

  def render_calculation(status: :ok)
    status = :unprocessable_entity if @error

    respond_to do |format|
      format.turbo_stream { render :calculate, status: status }
      format.html { render :show, status: status }
    end
  end
end

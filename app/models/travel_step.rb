class TravelStep
  MANEUVER_SPECS = {
    "launch" => { label: "Launch", coefficient: 0.042, offset: 33 }.freeze,
    "land" => { label: "Land", coefficient: 0.033, offset: 42 }.freeze
  }.freeze

  attr_reader :maneuver, :body

  def self.known_maneuver?(maneuver)
    MANEUVER_SPECS.key?(maneuver.to_s)
  end

  def self.launch(body)
    new(maneuver: "launch", body: body)
  end

  def self.land(body)
    new(maneuver: "land", body: body)
  end

  def initialize(maneuver:, body:)
    @maneuver = maneuver.to_s
    unless self.class.known_maneuver?(@maneuver)
      raise ArgumentError, "Unknown maneuver: #{maneuver.inspect}"
    end

    @body = body.is_a?(CelestialBody::Record) ? body : CelestialBody.find(body)
  end

  def gravity
    body.gravity
  end

  def coefficient
    spec.fetch(:coefficient)
  end

  def offset
    spec.fetch(:offset)
  end

  def label
    spec.fetch(:label)
  end

  def body_name
    body.name
  end

  def launch?
    maneuver == "launch"
  end

  def land?
    maneuver == "land"
  end

  private

  def spec
    MANEUVER_SPECS.fetch(maneuver)
  end
end

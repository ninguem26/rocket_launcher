class CelestialBody
  Record = Data.define(:key, :name, :gravity)

  CATALOG = [
    Record.new(key: "earth", name: "Earth", gravity: 9.807),
    Record.new(key: "moon", name: "Moon", gravity: 1.62),
    Record.new(key: "mars", name: "Mars", gravity: 3.711)
  ].freeze

  INDEX = CATALOG.index_by(&:key).freeze

  def self.all
    CATALOG
  end

  def self.keys
    INDEX.keys
  end

  def self.find(key)
    INDEX.fetch(key.to_s) do
      raise ArgumentError, "Unknown celestial body: #{key.inspect}"
    end
  end

  def self.gravity_map
    INDEX.transform_values(&:gravity)
  end
end

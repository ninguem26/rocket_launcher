class TravelPath
  def self.sequence_error(steps)
    Array(steps).each_cons(2) do |previous, current|
      if previous.land?
        unless current.launch? && current.body.key == previous.body.key
          return "After landing on #{previous.body_name}, the next action must be a launch from #{previous.body_name}."
        end
      else
        unless current.land?
          return "After launching from #{previous.body_name}, the next action must be a landing."
        end
      end
    end

    nil
  end
end

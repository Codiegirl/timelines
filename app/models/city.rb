class City < ApplicationRecord
  has_many :positions
  has_many :employers, through: :positions
  has_many :people, through: :positions

  has_many :events_as_destination, :class_name => "Event", :foreign_key => "destination_id"
  has_many :visitors_as_destination, :through => :events_as_destination, :source => :visitor

  def average_residency
    durations = self.positions.map do |position|
        position.finish_date - position.start_date
        end
      if durations != []
        average_seconds = durations.inject(:+)/durations.length
      else
        average_seconds = 0
      end
      average_seconds
  end

  def co_residents
    coincidences = []
      all_positions = self.positions
      self.positions.each do |position|
        all_other_positions = all_positions.select do |other_position|
          position != other_position
        end
          all_other_positions.each do |remaining_position|
            if remaining_position.start_date <= position.finish_date && remaining_position.finish_date >= position.start_date
                if remaining_position.start_date >= position.start_date
                  last_start = remaining_position.start_date
                else
                  last_start = position.start_date
                end
                if remaining_position.finish_date <= position.finish_date
                    first_finish = remaining_position.finish_date
                else
                  first_finish = position.finish_date
                end
              coincidences << [position, remaining_position, last_start, first_finish]
            end
          end
      end
      coincidences.each do |coincidence|
        coincidences.each do |other_coincidence|
          if coincidence[0] == other_coincidence[1] && coincidence[1] == other_coincidence[0]
            coincidences.delete(other_coincidence)
          end
        end
      end
    coincidences
    end





















end

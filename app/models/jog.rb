class Jog < ApplicationRecord
  include ActiveModel::Serialization

  belongs_to :user
  attr_readonly :user_id, :id

  validates :time, numericality: {
    only_integer: true,
    greater_than: 0,
    message: "must be at least 1 second"
  }

  def pretty_time=(raw_time)
    self.time = ChronicDuration.parse(raw_time)
  end

  def pretty_distance=(new_dist)
    self.distance = Unit.new(new_dist).convert_to("mile").scalar.round(3)
  end

  def speed
    ((self.distance.to_f * 3600) / self.time).round(3)
  end

  # def as_json(options = nil)
  #   answer = super(options)
  #   if options && options[:timeify]
  #     answer[:pretty_time] = Time.at(self.time).getgm.strftime("%H:%M:%S")
  #   end
  #   answer
  # end
  def as_json(options = nil)
    if options && options[:timeify]
      options[:except] = Array(options[:except]).map(&:to_s) | %w[time]
      options[:methods] = Array(options[:methods]).map(&:to_s) | %w[pretty_time]
    end
    super(options)
  end

  def read_attribute_for_serialization(key)
    # key == "pretty_time" ? self["pretty_time"] : super(key)
    self.has_attribute?(key) ? self[key] : super(key)
  end

  def pretty_time
    Time.at(self.time).getgm.strftime("%H:%M:%S")
  end

end

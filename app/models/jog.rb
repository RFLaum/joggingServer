class Jog < ApplicationRecord
  belongs_to :user
  attr_readonly :user_id, :id

  def pretty_time=(raw_time)
    self.time = ChronicDuration.parse(raw_time)
  end

  # def jsoner
  #   select("time * interval '1 second' as pretty_time")
  # end

  def as_json(options = nil)
    answer = super(options)
    if options && options[:timeify]
      answer[:pretty_time] = Time.at(self.time).getgm.strftime("%H:%M:%S")
    end
    answer
  end



end

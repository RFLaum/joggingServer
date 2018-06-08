class Jog < ApplicationRecord
  belongs_to :user
  attr_readonly :user_id, :id

  #displays time as a string
  def pretty_time
    Time.at(self.time).getgm.strftime("%k:%M:%S")
  end

  #average speed for this run
  def average_speed
    dist = Unit.new([self.distance, "miles"])
    tm   = Unit.new([self.time,     "seconds"])
    (dist/tm).to("mph").scalar.to_f.round(2)
  end

  # Automatically prettifies the json we're sending back, if clean: true is
  # passed in the options hash
  def as_json(options = nil)
    if options[:clean]
      options[:except] ||= []
      options[:methods] ||= []
      options[:except].concat(%i[user_id time])
      options[:methods].concat(%i[average_speed pretty_time])
    end
    super(options)
  end

end

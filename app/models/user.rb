class User < ApplicationRecord
  has_secure_password
  has_many :jogs
  attr_readonly :id

  enum role: %i[user manager admin]

  def week_list
    speed = "ROUND(CAST(SUM(distance) * 3600 / SUM(time) as numeric), 3)"
    dist  = "ROUND(CAST(AVG(distance) as numeric), 3)"
    week  = "CAST(DATE_TRUNC('week', date + 1) - interval '1 day' as date)"
    self.jogs
        .select("#{speed} as avg_speed, #{dist} as avg_dist, " \
                "COUNT(id) as num, #{week} as weekdate")
        .group("weekdate")
        .order("weekdate DESC")
  end

  def as_json(options = nil)
    if options[:clean]
      options[:only] = %i[username id role]
    end
    super(options)
  end
end

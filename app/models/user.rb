class User < ApplicationRecord
  has_secure_password
  has_many :jogs
  attr_readonly :id

  enum role: %i[user manager admin]

  validates :username, uniqueness: true

  SPD_Q = "CAST(ROUND(CAST(SUM(distance) * 3600 / SUM(time) as numeric), 3) as float)".freeze
  DIST_Q = "CAST(ROUND(CAST(AVG(distance) as numeric), 3) as float)".freeze
  WK_Q = "CAST(DATE_TRUNC('week', date + 1) - interval '1 day' as date)".freeze

  def week_list
    # speed = "ROUND(CAST(SUM(distance) * 3600 / SUM(time) as numeric), 3)"
    # dist  = "ROUND(CAST(AVG(distance) as numeric), 3)"
    # week = "CAST(DATE_TRUNC('week', date + 1) - interval '1 day' as date)"
    self.jogs
        .select("#{SPD_Q} AS avg_speed", "#{DIST_Q} AS avg_dist",
                "COUNT(*) AS num", "#{WK_Q} AS weekdate")
        .group("weekdate")
        .order("weekdate DESC")
  end

  def week_count
    self.jogs.select(WK_Q).distinct.count
  end

  # def single_week(start_date)
  #   return unless start_date.acts_like_date?
  #   monday = start_date + 1
  #   cand_jogs = self.jogs.where("DATE_TRUNC('week', date + 1) = ?", monday)
  #   cand_jogs.select("#{SPD_Q} AS avg_speed", "#{DIST_Q} AS avg_dist",
  #                    "COUNT(*) AS num")
  # end

  def as_json(options = nil)
    if options && options[:clean]
      options[:only] = %i[username id role]
    end
    super(options)
  end

  def all_jogs(start_date, end_date)
    self.jogs_range(start_date, end_date)
        .select(:id, :date, :distance, :user_id,
                "time * interval '1 second' as pretty_time",
                "CAST(ROUND(CAST(distance * 3600 / time as numeric), 3) as float) as speed")
        .order("date DESC")
  end

  def jogs_range(start_date, end_date)
    temp_jogs = self.jogs
    if start_date
      temp_jogs = temp_jogs.where("date >= ?", Date.parse(start_date))
    end
    if end_date
      temp_jogs = temp_jogs.where("date <= ?", Date.parse(end_date))
    end
    temp_jogs
  end

  def viewable_users
    answer = nil
    case self.role
    when "user"
      answer = self
    when "admin"
      answer = User.all
    when "manager"
      answer = User.where(role: :user).or(User.where(id: self.id))
    end
    answer.order(username: :asc)
  end

  def can_view_jogs?(other_user)
    self.admin? || self == other_user
    # return true if self.admin? || self == other_user
    # return false if self.user?
    # self.manager? && other_user.user?
  end

  def can_view_userdata?(other_user)
    return true if self.admin? || self == other_user
    return false if self.user?
    self.manager? && other_user.user?
  end

end

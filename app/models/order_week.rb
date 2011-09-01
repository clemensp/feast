class OrderWeek
  include Mongoid::Document
  include Mongoid::Timestamps

  field :date, :type => Date

  def self.this_week
    OrderWeek.find_or_create_by :date => this_friday
  end

  def self.this_friday
    Time.zone.now.to_date + (5 - Time.zone.now.wday).days
  end
end

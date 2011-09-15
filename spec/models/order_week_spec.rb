require 'spec_helper'

describe OrderWeek do
  before do
    Timecop.travel 1.week.ago do
      OrderWeek.this_week
    end
  end

  describe ".this_week" do
    it "should create a new order week if it does not exist" do
      expect {
        OrderWeek.this_week
      }.to change{OrderWeek.count}.by(1)
    end

    it "should find the current week if it exists" do
      this_week = OrderWeek.this_week
      expect {
        OrderWeek.this_week
      }.to_not change{OrderWeek.count}
    end
  end

  describe ".this_friday" do
    it "should return the friday of the current week on sunday" do
      Timecop.freeze Time.zone.parse("2011-08-28") do
        assert_equal "2011-09-02", OrderWeek.this_friday.to_s
      end
    end

    it "should return the friday of the current week on thursday" do
      Timecop.freeze Time.zone.parse("2011-09-01") do
        assert_equal "2011-09-02", OrderWeek.this_friday.to_s
      end
    end

    it "should return the friday of the current week on saturday" do
      Timecop.freeze Time.zone.parse("2011-09-03") do
        assert_equal "2011-09-02", OrderWeek.this_friday.to_s
      end
    end
  end

  describe "#orderers" do
    it "should return the users who have ordered this week" do

    end
  end
end

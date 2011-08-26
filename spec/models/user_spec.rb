require 'spec_helper'

describe User do
  describe "#find_or_create_by_token" do
    let(:email) {'foo@nulogy.com'}
    let(:token) do
      {
        'user_info' => {
          'email' => email
        }
      }
    end

    it "can find a user with a user token" do
      user = User.make! email: email
      result = User.find_or_create_by_token(token)

      result.should == user
    end

    it "can create a user with a user token" do
      user = User.make! email: email
      User.find_or_create_by_token(token)
      User.all.count.should == 1
    end
  end

  describe "#orderers" do
    it "lists users who have ordered this week" do
      users = User.make! 2
      users.each {|u| u.order("Beef Burger" => 5)}

      orderers = User.orderers

      orderers.length.should == 2
      users.each do |user|
        orderers.include?(user).should be_true
      end
    end

    it "does not include users who have not ordered this week" do
      not_included = nil
      Timecop.travel 2.weeks.ago do
        not_included = User.make!
        not_included.order('Beef Burger' => 10)
      end

      included = User.make!
      included.order("Beef Burger" => 10)

      orderers = User.orderers

      orderers.include?(included).should be_true
      orderers.include?(not_included).should be_false
    end
  end

  describe "#non_orderers" do
    it "lists users who have not ordered this week" do
      users = User.make! 2

      non_orderers = User.non_orderers

      non_orderers.length.should == 2
      users.each do |user|
        non_orderers.include?(user).should be_true
      end
    end

    it "does not include users who have ordered this week" do
      included = nil
      Timecop.travel 8.days.ago do
        included = User.make!
        included.order('Beef Burger' => 10)
      end

      excluded = User.make!
      excluded.order("Beef Burger" => 10)

      non_orderers = User.non_orderers

      non_orderers.include?(excluded).should be_false
      non_orderers.include?(included).should be_true
    end

    it "should not list users who have ordered last week but not this week" do
      user = User.make!
      Timecop.travel 15.days.ago do
        user.order("Beef Burger" => 2)
      end
      Timecop.travel 8.days.ago do
        user.order("Beef Burger" => 2)
      end

      User.non_orderers.include?(user).should == true
      User.orderers.include?(user).should == false
    end
  end
end

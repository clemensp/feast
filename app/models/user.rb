class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise \
    :omniauthable,
    :database_authenticatable,
    :registerable,
    :validatable

  embeds_many :orders

  def self.find_or_create_by_token(token)
    email = token['user_info']['email']
    where(:email => email).first or create(:email => email, :password => 'foobar')
  end

  def self.orderers
    all(conditions: { "orders.order_week_id" => OrderWeek.this_week.id})
  end

  def self.non_orderers
    all(conditions: { "orders.order_week_id" => { "$ne" => OrderWeek.this_week.id}})
  end

  def order(food)
    if already_ordered?
      Order.errored("You cannot place another order this week")
    else
      orders.create! food.merge({:order_week => OrderWeek.this_week})
    end
  end

  def already_ordered?
    not current_order.nil?
  end

  def current_order
    orders.where(:order_week_id => OrderWeek.this_week.id).first
  end

  def previous_orders
    orders.where(:order_week_id.ne => OrderWeek.this_week.id)
  end
end

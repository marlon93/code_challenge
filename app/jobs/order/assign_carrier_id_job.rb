class Order
  class AssignCarrierIdJob < ActiveJob::Base
    queue_as :default

    def perform(order_id)
      order = Order.find_by(id: order_id)
      return if order.nil? || order.carrier_id.present?

      order.assign_carrier_id!
    end
  end
end

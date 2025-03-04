class Order
  class CheckOrderStatusJob < ActiveJob::Base
    queue_as :default

    def perform(order_id)
      order = Order.find_by(id: order_id)

      return unless order

      order.update_status_from_provider!
    end
  end
end

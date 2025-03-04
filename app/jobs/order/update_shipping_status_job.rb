class Order
  class UpdateShippingStatusJob < ActiveJob::Base
    queue_as :default

    def perform
      Order.excluding_delivered.select(:id).find_each(batch_size: 1000) do |order|
        Order::CheckOrderStatusJob.perform_later(order.id)
      end
    end

    after_perform do
      Order::OperationManagerMailer.send_email.deliver_now
    end
  end
end

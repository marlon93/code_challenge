class Order
  module UpdateStatusFromProvider
    extend ActiveSupport::Concern

    included do
      def update_status_from_provider!
        "Order::Provider::#{carrier_name.capitalize}Strategy".safe_constantize.tap do |adapter_class|
          return false unless adapter_class

          adapter_class.update_status(self)
        end
      end

      def assign_carrier_id!
        shipping_provider = "#{carrier_name.capitalize}::Shipment".safe_constantize
        return false if shipping_provider.nil?

        update!(carrier_id: shipping_provider.create.id)
        true
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique, NoMethodError => e
        Rails.logger.error("#{e.class}: #{e.message} while assigning carrier_id in order #{id}")
        false
      end
    end
  end
end

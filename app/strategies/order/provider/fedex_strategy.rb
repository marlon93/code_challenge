class Order
  module Provider
    class FedexStrategy < BaseStrategy
      def self.update_status(order)
        return if delivered?(order)

        shipment = fetch_shipment(order)
        new_status = status_index_for(shipment.status)

        order.update!(status: new_status) if new_status
      rescue Fedex::ShipmentNotFound, NoMethodError => e
        handle_missing_shipment(order, e)
      end

      private

      def self.delivered?(order)
        order.status == Order::STATUS.index('delivered')
      end

      def self.status_index_for(shipment_status)
        Order::STATUS.index(shipment_status)
      end

      def self.fetch_shipment(order)
        return Fedex::Shipment.find(order.carrier_id) if order.carrier_id.present?

        Fedex::Shipment.create
      end

      def self.handle_missing_shipment(order, error)
        order.update!(carrier_id: nil)
        Rails.logger.error("Shipment not found for order #{order.id}: #{error.message}")
      end
    end
  end
end

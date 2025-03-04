class Order
  module Statusable
    extend ActiveSupport::Concern

    included do
      STATUS = ['processing'].concat(available_statuses).freeze
    end

    class_methods do
      def available_statuses
        [
          Fedex::Shipment::STATUS
        ].flatten.uniq
      end
    end
  end
end

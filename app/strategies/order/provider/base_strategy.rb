class Order
  module Provider
    class BaseStrategy
      def self.update_status(order)
        raise NotImplementedError, 'You must implement the update_status method'
      end
    end
  end
end

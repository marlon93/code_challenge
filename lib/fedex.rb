# NOTE: Do not modify this file!

# A client library for FedEx shipping.
#
# @example Creating a shipment
#   shipment = Fedex::Shipment.create
#   puts shipment.status
#   puts shpiment.id
#
# @example Getting status updates for a shipment
#   shipment = Fedex::Shipment.find(shipment_id)
#   puts shipment.status
module Fedex
  class ShipmentNotFound < StandardError; end

  # A class representing a shipment in Fedex's system.
  class Shipment

    STATUS = [
      'awaiting_pickup',
      'in_transit',
      'out_for_delivery',
      'delivered'
    ].freeze

    # Current status of the shipment in Fedex's system. Returns a string in
    # ['awaiting_pickup', 'in_transit', 'out_for_delivery', 'delivered']. The
    # status can transition to any other status due to mistakes FedEx
    # operators/drivers make.
    attr_accessor :status

    # Unique ID of the shipment. After a shipment is created, you can use the
    # ID to reload the shipment and get its updated status.
    attr_accessor :id

    # Creates a new shipment
    #
    # @return [Shipment] a new shipment, initially in the 'awaiting_pickup' state.
    #
    def self.create
      @shipments ||= {}
      @next_id ||= 0

      shipment = Shipment.new
      shipment.status = 'awaiting_pickup'
      shipment.id = (@next_id += 1)

      @shipments[shipment.id] = shipment

      shipment
    end

    # Fetches and returns a shipment with the latest updates available.
    #
    # @param fedex_id [String] ID of the shipment to find
    # @return [Shipment] a shipment with updated status
    # @raise [ShipmentNotFound] if the shipment can't be found
    #
    def self.find(fedex_id)
      shipment = @shipments[fedex_id]

      raise ShipmentNotFound, "Shipment not found: #{fedex_id}" if shipment.blank?

      shipment.status = STATUS.shuffle.first

      shipment
    end
  end
end

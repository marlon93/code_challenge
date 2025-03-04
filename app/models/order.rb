class Order < ApplicationRecord
  include Statusable
  include Scopeable
  include UpdateStatusFromProvider

  DEFAULT_CARRIER = 'Fedex'.freeze
  DEFAULT_STATUS = 'processing'.freeze

  belongs_to :product, optional: false

  validates :product_id, :customer_name, :status, :carrier_name, presence: true

  before_validation :set_defaults
  after_commit :decrement_stock, :assign_carrier_id, on: :create

  def soft_delete!
    update!(deleted_at: Time.current)
  end

  private

  def set_defaults
    self.status ||= Order::STATUS.index(DEFAULT_STATUS)
    self.carrier_name ||= DEFAULT_CARRIER
  end

  def decrement_stock
    product.decrement!(:stock)
  end

  def assign_carrier_id
    Order::AssignCarrierIdJob.perform_later(id)
  end
end

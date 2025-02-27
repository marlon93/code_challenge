class Order
  module Scopeable
    extend ActiveSupport::Concern

    class_methods do
      def optional_scope(name, &block)
        scope name, ->(value) { value.present? ? instance_exec(value.strip, &block) : all }
      end
    end

    included do
      default_scope { where(deleted_at: nil) }

      scope :excluding_delivered, -> {
        where.not(status: Order::STATUS.index('delivered'))
      }

      optional_scope :by_customer do |name|
        where("customer_name ILIKE ?", "%#{name}%")
      end

      optional_scope :by_status do |status_name|
        if Order::STATUS.include?(status_name)
          where(status: Order::STATUS.index(status_name))
        else
          all
        end
      end

      optional_scope :by_product_name do |product_name|
        joins(:product).where("products.name ILIKE ?", "%#{product_name}%")
      end

      def self.safe_parse_date(date)
        Time.zone.parse(date) rescue nil
      end

      optional_scope :from_date do |date|
        if (parsed_date = safe_parse_date(date))
          where("orders.created_at >= ?", parsed_date.beginning_of_day)
        else
          all
        end
      end

      optional_scope :to_date do |date|
        if (parsed_date = safe_parse_date(date))
          where("orders.created_at <= ?", parsed_date.end_of_day)
        else
          all
        end
      end

      def self.filter(filters)
        all.
          by_customer(filters[:customer_name]).
          by_status(filters[:status]).
          by_product_name(filters[:product_name]).
          from_date(filters[:from_date]).
          to_date(filters[:to_date])
      end
    end
  end
end

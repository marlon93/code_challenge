class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy]
  before_action :set_products, only: %i[new edit create update]

  def index
    @orders = Order.filter(params.fetch(:filters, {})).page(params[:page]).per(3)
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to orders_path, notice: t('orders.create.success')
    else
      flash.now[:alert] = t('orders.create.error', errors: @order.errors.full_messages.to_sentence)
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @order.update(order_params)
      redirect_to orders_path, notice: t('orders.update.success')
    else
      flash.now[:alert] = t('orders.update.error', errors: @order.errors.full_messages.to_sentence)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.soft_delete!
    redirect_to orders_path, notice: t('orders.destroy.success')
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_products
    @products = Product.with_stock
  end

  def order_params
    params.require(:order).permit(:product_id, :customer_name)
  end
end

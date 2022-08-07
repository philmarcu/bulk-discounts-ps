class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.bulk_discounts.new(discount_params)

    if discount.save
      redirect_to "/merchants/#{merchant.id}/bulk_discounts"
    else
      redirect_to "/merchants/#{merchant.id}/bulk_discounts/new"
      flash[:alert] = "Error: #{error_message(discount.errors)}"
    end
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  private

  def discount_params
    params.permit(:name, :qty_threshold, :pct_discount)
  end
end
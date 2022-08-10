class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @holidays = NagerFacade.holidays
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

  def edit
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    discount = BulkDiscount.find(params[:id])

    if discount.update(discount_params)
      redirect_to "/merchants/#{discount.merchant_id}/bulk_discounts/#{discount.id}"
      flash[:success] = "Update was successful!"
    else
      redirect_to "/merchants/#{discount.merchant_id}/bulk_discounts/#{discount.id}/edit"
      flash[:alert] = "Error: #{error_message(discount.errors)}"
    end
  end

  private

  def discount_params
    params.permit(:name, :qty_threshold, :pct_discount)
  end
end
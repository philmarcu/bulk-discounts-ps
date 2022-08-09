require 'rails_helper'  

RSpec.describe DiscountItem do
  describe 'validations' do
    it { should validate_presence_of(:quantity)}
    it { should validate_presence_of(:price)}
  end

  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :bulk_discount }
    it { should have_many(:invoices).through(:item) }
  end
end
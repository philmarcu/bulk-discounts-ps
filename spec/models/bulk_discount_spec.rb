require 'rails_helper'

RSpec.describe BulkDiscount do
  describe 'validations' do
    it { should validate_presence_of(:qty_threshold)}
    it { should validate_presence_of(:pct_discount)}
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:items).through(:merchant)}
  end
end
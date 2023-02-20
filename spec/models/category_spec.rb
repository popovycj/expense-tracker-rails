require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'relationships' do
    it { should have_many(:expenses) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end

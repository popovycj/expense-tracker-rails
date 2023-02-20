require 'rails_helper'

RSpec.describe Expense, type: :model do
  describe 'relationships' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:description) }
    it { should validate_length_of(:description).is_at_most(255) }
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:category) }
    it do
      should define_enum_for(:visibility)
        .with_values(private: 0, public: 1)
        .with_prefix(:visibility)
        .backed_by_column_of_type(:integer)
    end
  end

  describe 'scopes' do
    it "should have public expenses" do
      public_expense = create(:expense, visibility: "public")
      private_expense = create(:expense, visibility: "private")

      expect(Expense.public_expenses).to include(public_expense)
      expect(Expense.public_expenses).to_not include(private_expense)
    end

    it "should have expenses from the last month" do
      recent_expense = create(:expense, created_at: 2.days.ago)
      old_expense = create(:expense, created_at: 31.days.ago)

      expect(Expense.last_month_expenses).to include(recent_expense)
      expect(Expense.last_month_expenses).to_not include(old_expense)
    end
  end
end

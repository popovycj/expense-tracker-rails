require 'rails_helper'

RSpec.describe ExpensesController, type: :request do
  let!(:user) { create(:user) }
  let!(:expense) { create(:expense, user: user) }

  describe "GET #index" do
    context "when user is not authenticated" do
      it "redirects to login page" do
        get expenses_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      before { sign_in user }

      it "returns http success" do
        get expenses_path
        expect(response).to have_http_status(:success)
      end

      context "with category_id parameter" do
        let(:category) { create(:category) }
        let!(:expense) { create(:expense, category: category, user: user) }

        it "filters expenses by category" do
          get expenses_path(category_id: category.id)
          expect(assigns(:expenses)).to contain_exactly(expense)
        end
      end

      context "with start_date and end_date parameters" do
        let!(:expense) { create(:expense, user: user, created_at: 2.days.ago) }

        it "returns only expenses within the specified date range" do
          get expenses_path(start_date: 3.days.ago, end_date: Time.current)
          expect(assigns(:expenses)).to contain_exactly(expense)
        end
      end
    end
  end

  describe "GET #show" do
    context "when user is not authenticated" do
      it "redirects to login page" do
        get expense_path(expense)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      before { sign_in user }

      it "returns http success" do
        get expense_path(expense)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET #new" do
    context "when user is not authenticated" do
      it "redirects to login page" do
        get new_expense_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      before { sign_in user }

      it "returns http success" do
        get new_expense_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "POST #create" do
    context "when user is not authenticated" do
      let!(:valid_attributes) { create(:expense).attributes }

      it "redirects to login page" do
        post expenses_path, params: { expense: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end

      it "does not create a new expense" do
        expect {
          post expenses_path, params: { expense: valid_attributes }
        }.to change(Expense, :count).by(0)
      end
    end

    context "when user is authenticated" do
      before { sign_in user }

      context "with valid parameters" do
        let!(:expense_params) { create(:expense).attributes.except("user_id") }

        it "creates a new expense" do
          expect {
            post expenses_path, params: { expense: expense_params, format: :turbo_stream }
          }.to change(user.expenses, :count).by(1)
        end
      end

      context "with invalid parameters" do
        let!(:expense_params) { { amount: -1 } }

        it "renders the 'new' template" do
          post expenses_path, params: { expense: expense_params }
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe "GET #edit" do
    context "when user is not authenticated" do
      it "redirects to login page" do
        get edit_expense_path(expense)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      before { sign_in user }

      it "returns http success" do
        get edit_expense_path(expense)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PUT #update" do
    context "when user is not authenticated" do
      let!(:expense) { create(:expense) }
      let!(:valid_attributes) { create(:expense).attributes }

      it "redirects to login page" do
        put expense_path(expense), params: { id: expense.id, expense: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end

      it "does not update the expense" do
        original_attributes = expense.attributes
        put expense_path(expense), params: { id: expense.id, expense: valid_attributes }
        expect(expense.reload.attributes).to eq(original_attributes)
      end
    end

    context "when user is authenticated" do
      before { sign_in user }

      context "with valid params" do
        let(:updated_category) { create(:category) }
        let(:expense_params) { attributes_for(:expense, category_id: updated_category.id) }

        it "updates the expense" do
          put expense_path(expense), params: { expense: expense_params, format: :turbo_stream }
          expense.reload
          expect(expense.category).to eq(updated_category)
        end
      end

      context "with invalid params" do
        let!(:expense_params) { { amount: -1 } }

        it "renders the 'edit' template" do
          put expense_path(expense), params: { expense: expense_params }
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "when user is not authenticated" do
      let!(:expense) { create(:expense) }
      let!(:valid_attributes) { create(:expense).attributes }

      it "redirects to login page" do
        delete expense_path(expense)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      before { sign_in user }

      it "destroys the expense" do
        expect {
          delete expense_path(expense), params: { format: :turbo_stream }
        }.to change(user.expenses, :count).by(-1)
      end
    end
  end
end

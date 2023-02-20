require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #index" do
    context "when user is not authenticated" do
      it "redirects to login page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      before { sign_in user }

      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns @users" do
        user1 = create(:user)
        user2 = create(:user)
        get :index
        expect(assigns(:users)).to match_array([user, user1, user2])
      end
    end
  end

  describe "GET #show_expenses" do
    context "when user is not authenticated" do
      it "redirects to login page" do
        get :show_expenses, params: { id: user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      before { sign_in user }

      let!(:category) { create(:category) }
      let!(:expense1) { create(:expense, user: user, category: category, created_at: 2.days.ago) }
      let!(:expense2) { create(:expense, user: user, category: category, created_at: 1.day.ago) }

      it "returns http success" do
        get :show_expenses, params: { id: user.id }
        expect(response).to have_http_status(:success)
      end

      it "assigns @user" do
        get :show_expenses, params: { id: user.id }
        expect(assigns(:user)).to eq(user)
      end

      it "assigns @expenses" do
        get :show_expenses, params: { id: user.id }
        expect(assigns(:expenses)).to match_array([expense1, expense2])
      end

      context "when filtering by category" do
        let!(:category2) { create(:category) }
        let!(:expense3) { create(:expense, user: user, category: category2, created_at: 3.days.ago) }

        it "assigns @expenses for the selected category" do
          get :show_expenses, params: { id: user.id, category_id: category.id }
          expect(assigns(:expenses)).to match_array([expense1, expense2])
        end

        it "does not include expenses for other categories" do
          get :show_expenses, params: { id: user.id, category_id: category.id }
          expect(assigns(:expenses)).not_to include(expense3)
        end
      end

      context "when filtering by date range" do
        let!(:expense3) { create(:expense, user: user, category: category, created_at: 4.days.ago) }

        it "assigns @expenses within the selected date range" do
          get :show_expenses, params: { id: user.id, start_date: 3.days.ago.to_date, end_date: Time.current }
          expect(assigns(:expenses)).to match_array([expense1, expense2])
        end

        it "does not include expenses outside of the selected date range" do
          get :show_expenses, params: { id: user.id, start_date: 3.days.ago.to_date, end_date: Time.current }
          expect(assigns(:expenses)).not_to include(expense3)
        end
      end
    end
  end
end

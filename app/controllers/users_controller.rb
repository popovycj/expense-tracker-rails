class UsersController < ApplicationController
  def index
    @users = User.order(created_at: :desc)
  end

  def show
    @user = User.find_by(id: params[:id])

    @expenses = @user.expenses.public_expenses

    @expenses = @expenses.where(category: params[:category_id]) if params[:category_id].present?
    @expenses = @expenses.where(created_at: params[:start_date]..params[:end_date]) if params[:start_date].present? && params[:end_date].present?
  end
end

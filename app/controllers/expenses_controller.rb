class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  def index
    @expenses = current_user.expenses.order(created_at: :desc)

    @expenses = @expenses.where(category: params[:category_id]) if params[:category_id].present?
    @expenses = @expenses.where(created_at: params[:start_date]..params[:end_date]) if params[:start_date].present? && params[:end_date].present?
  end

  def show
  end

  def new
    @expense = current_user.expenses.build
  end

  def create
    @expense = current_user.expenses.build(expense_params)

    if @expense.save
      flash.now[:success] = "Expense was created"

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend('expenses',
                                  partial: 'expenses/expense',
                                  locals: { expense: @expense }),
            turbo_stream.update('total_expenses', "Need to be clarified"),
            turbo_stream.prepend("flash", partial: "layouts/flash")
          ]
        end
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @expense.update(expense_params)
      flash.now[:success] = "Expense was updated"

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(@expense,
                                partial: "expenses/expense_inner",
                                locals: {expense: @expense}),
            turbo_stream.update('total_expenses', "Need to be clarified"),
            turbo_stream.prepend("flash", partial: "layouts/flash")
          ]
        end
      end
    else
      render :edit
    end
  end

  def destroy
    @expense.destroy
    flash.now[:success] = "Expense was deleted"

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@expense),
          turbo_stream.update('total_expenses', "Need to be clarified"),
          turbo_stream.prepend("flash", partial: "layouts/flash")
        ]
      end
    end
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:category_id, :description, :amount, :visibility, :created_at)
  end
end

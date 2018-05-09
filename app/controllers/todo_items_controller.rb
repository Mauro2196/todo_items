class TodoItemsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :basic_auth

  def index
    todo_items = TodoItem.all
    render json: todo_items
  end

  def create
    todo_item = TodoItem.new(todo_item_params)
    if todo_item.save
      render json: todo_item
    else
      render json: { errors: todo_item.errors }, status: 422
    end
  end

  def update
    todo_item = TodoItem.find(params[:id])
    if todo_item.update(todo_item_params)
      render json: todo_item
    else
      render json: { errors: todo_item.errors }, status: 422
    end
  end

  def destroy
    todo_item = TodoItem.find(params[:id])
    todo_item.destroy

    head :no_content
  end

  private
    def todo_item_params
      params.require(:todo_item).permit(:title, :done)
    end

    def basic_auth
      authenticate_or_request_with_http_basic do |email, token|
        user = User.find_by(email: email)
        if user && user.auth_token == token
          sign_in user
        end
      end
    end
end

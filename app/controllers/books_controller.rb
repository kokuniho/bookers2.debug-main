class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    # @books=Book.new
    @book = Book.find(params[:id])
    @user=User.find_by(id: @book.user_id )
    @book_comment = BookComment.new
  end

  def index
    @books = Book.all
    if params[:sort_create]
      @books = Book.all.order(created_at: :desc)
    else params[:sort_evaluation]
      @books = Book.all.order("evaluation DESC")
    end
    @books = @books.order(params[:change])
    @book=Book.new
    @user=current_user
  end

  def create
    @book=Book.new(book_params)
    @book.user_id = current_user.id
    @books=Book.all
    @users=User.all
    @user = current_user

    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])

  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end

    # if evaluation_count < 1
    #     @evaluation.save
    # end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :evaluation)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
     redirect_to books_path
    end
  end
end









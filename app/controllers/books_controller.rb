class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    # @books=Book.new
    @book = Book.find(params[:id])
    @user=User.find_by(id: @book.user_id )
    @book_comment = BookComment.new
    # @tag = Tag.find(params[:tag_id])

  end

  def index
    @books = Book.all
    @books = @books.where('tag LIKE ?', "%#{params[:search]}%") if params[:search].present?
    
    if params[:sort_create]
      @books = Book.all.order(created_at: :desc)
    elsif params[:sort_evaluation]
      @books = Book.all.order("evaluation DESC")
    elsif params[:tag_id]
       @tag = Tag.find(params[:tag_id])
       @books = @tag.books.order(created_at: :desc).all
    else
       @books = Book.order(created_at: :desc).all
    end

    @books = @books.order(params[:change])
    @book=Book.new
    @user=current_user
  # tag検索


    # @books = params[:tag_id].present? ? Tag.find(params[:tag_id]).books : Book.all
    # # @books = Kaminari.paginate_array(items).page(params[:page]).per(10)
  end

  def create
    @book=Book.new(book_params)
    tag_list = params[:book][:tag_name].split(nil)
    @book.user_id = current_user.id
    if @book.save
       @book.save_books(tag_list)
     redirect_to book_path(@book), notice: "You have created book successfully."
    else
       @books = Book.all
        render :index
    end
    @books=Book.all
    @users=User.all
    @user = current_user

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
    params.require(:book).permit(:title, :body, :evaluation, :tag_id)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
     redirect_to books_path
    end
  end
end









class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]
    @method = params[:method]

    if @range == "User"
      @users = User.looks(params[:search], params[:word], params[:method])
    elsif @range =="Book"
      @books = Book.looks(params[:search], params[:word], params[:method])
    elsif @range == "Tag"
      @records = Tag.looks(params[:search], params[:word], params[:method])

    end

    @user = User.all
    @books = Book.all

  end
end

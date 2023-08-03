class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_comment=BookComment.new
    @user=@book.user
    #アクセスした回数
    view_count=ViewCount.new(user_id: current_user.id, book_id: @book.id)
    view_count.save

     #ユーザー（一度きりの回数）
    #unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      #current_user.view_counts.create(book_id: @book.id)
    #end
    #チャット
    @current_user_entry=Entry.where(user_id: current_user.id)
    @user_entry=Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @current_user_entry.each do |cu|
        @user_entry.each do |u|
          if cu.room_id == u.room_id then
            @is_room = true
            @roomid = cu.room_id
          end
        end
      end
      if @is_room
      else
        @room = Room.new
        @entry = Entry.new
      end
    end

  end

  def index
    @book=Book.new
    @books = Book.all
    if params[:latest]
      @books = Book.latest
    elsif params[:star_count]
      @books=Book.star_count
    else
      to=Time.current.at_end_of_day
      from=(to-6.day).at_beginning_of_day
      #いいね順に一覧を表示
      @books=Book.includes(:favorites).sort_by{|x| x.favorites.where(created_at: from...to).size}.reverse
    end

  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit

  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :star, :tag)
  end

  def ensure_correct_user
    @book=Book.find(params[:id])
    unless @book.user==current_user
      redirect_to books_path
    end
  end
end

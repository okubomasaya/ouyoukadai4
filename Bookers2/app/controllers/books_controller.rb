class BooksController < ApplicationController
    before_action :authenticate_user!
    before_action :check_current_user, only: [:edit, :update, :destroy]

    def index
        @books = Book.all
    end

    def create
        @book_new = Book.new(book_params)
        @book_new.user_id = current_user.id
        if @book_new.save
            flash[:notice] = "You have created book successfully."
            redirect_to book_path(@book_new.id)
        else
            @books = Book.all
            @user = User.find(current_user.id)
            render("/books/index")
        end
    end

    def edit
        @book = Book.find(params[:id])
    end

    def show
        @book = Book.find(params[:id])
        @book_comment = BookComment.new
    end

    def update
        @book = Book.find(params[:id])
        if @book.update(book_params)
            flash[:notice] = "You have updated book successfully."
            redirect_to book_path(@book.id)
        else
            render ("/books/edit")
        end
    end

    def destroy
        book = Book.find(params[:id])
        flash[:notice] = "Book was successfully destroyed."
        book.destroy
        redirect_to("/books")
    end

    private
    def book_params
      params.require(:book).permit(:title, :body)
    end

    def check_current_user
        unless Book.find(params[:id]).user == current_user
            redirect_to books_path
        end
    end
end


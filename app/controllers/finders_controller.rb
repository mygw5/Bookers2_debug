class FindersController < ApplicationController
  def finder
   @user=User.find(params[:user_id])
   create_at=params[:created_at]
   @finder_book=@user.books.where(['created_at LIKE?', "#{create_at}%"]).count

  end

end

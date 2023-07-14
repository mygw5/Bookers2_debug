class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    #params[:range]検索モデル
    @range=params[:range]
    #params[:word]検索ワード
    @word=params[:word]

    if @range=="User"
      #params[:search]検索方法
      @users=User.looks(params[:search], params[:word])
    else
      @books=Book.looks(params[:search], params[:word])
    end
  end
end

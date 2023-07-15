class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    #params[:range]検索モデル
    @model=params[:model]
    #params[:word]検索ワード
    @content=params[:content]
    @method=params[:method]

    if @model=="user"
      #params[:search]検索方法
      @records=User.search_for(@content, @method)
    else
      @records=Book.search_for(@content, @method)
    end
  end
end

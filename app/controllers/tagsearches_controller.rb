class TagsearchesController < ApplicationController
  before_action :authenticate_user!
  def tagsearch
    @word=params[:tag]
    @books=Book.where("tag LIKE?", "#{@word}%")
    render "tagsearches/tag"
  end
end

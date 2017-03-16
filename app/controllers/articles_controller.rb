class ArticlesController < ApplicationController
  def new

  end

  def show
    @article = Article.find(params[:id])
  end


  def create
    @article = Article.new(article_params)

    @article.save

    redirect_to :action => 'show', :id => @article
  end

  private
    def article_params
      params.require(:article).permit(:title, :text)
    end
end

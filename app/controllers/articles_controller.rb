class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]
  def index
    @highlights = Article.order(created_at: :desc).first(3)
    current_page = (params[:page] || 1).to_i

    highlights_id = @highlights.pluck(:id).join(',')
    @articles = Article.order(created_at: :desc).where("id NOT IN(#{highlights_id})").page(current_page).per(2)
  end

  def show; end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      flash[:success] = 'Article successfully created'
      redirect_to @article
    else
      flash[:error] = 'Something went wrong'
      render 'new'
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      flash[:success] = 'Article was successfully updated'
      redirect_to @article
    else
      flash[:error] = 'Something went wrong'
      render 'edit'
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :body)
  end

  def set_article
    @article = Article.find(params[:id])
  end
end

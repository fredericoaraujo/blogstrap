class ArticlesController < ApplicationController
  include Paginable

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_article, only: %i[show edit update destroy]
  def index
    category_filter = Category.find_by_name(params[:category]) if params[:category].present?
    @highlights = Article.filter_by_category(category_filter).desc_order.first(3)
    highlights_id = @highlights.pluck(:id).join(',')
    current_page = (params[:page] || 1).to_i

    @articles = Article.wthout_highlights(highlights_id).filter_by_category(category_filter).desc_order.page(current_page)
    @categories = Category.sorted
  end

  def show; end

  def new
    @article = current_user.articles.new
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      redirect_to @article, notice: 'Article successfully created'
    else
      flash[:error] = 'Something went wrong'
      render 'new'
    end
  end

  def edit; end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated'
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
    params.require(:article).permit(:title, :body, :category_id)
  end

  def set_article
    @article = Article.find(params[:id])
    authorize @article
  end
end

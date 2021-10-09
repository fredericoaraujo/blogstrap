class ArticlesController < ApplicationController
  include Paginable

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_article, only: %i[show edit update destroy]
  before_action :set_categories, only: %i[index new edit create update]
  def index
    category_filter = @categories.select { |c| c.name == params[:category] }[0] if params[:category].present?
    @highlights = Article.includes(:category, :user)
                         .filter_by_category(category_filter)
                         .filter_by_archive(params[:month_year])
                         .desc_order.first(3)
    highlights_id = @highlights.pluck(:id).join(',')
    current_page = (params[:page] || 1).to_i

    @articles = Article.includes(:category, :user)
                       .wthout_highlights(highlights_id)
                       .filter_by_category(category_filter)
                       .filter_by_archive(params[:month_year])
                       .desc_order.page(current_page)

    @archives = Article.group_by_month(:created_at, format: '%B %Y').count
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

  def set_categories
    @categories = Category.sorted
  end
end

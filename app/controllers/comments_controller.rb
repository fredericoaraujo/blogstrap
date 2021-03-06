class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_article

    def create
        @article.comments.create(comments_params.to_h.merge!({ user_id: current_user.id }))
        redirect_to article_path(@article)
    end

    private

    def comments_params
        params.require(:comment).permit(:body)
    end

    def set_article
        @article = Article.find(params[:article_id])
    end
end

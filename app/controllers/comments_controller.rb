class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_campaign
  before_action :set_post
  before_action :set_comment, only: [:update]

  def index
    respond_to do |format|
      format.json { render json: CommentsDatatable.new(view_context, @post) }
    end
  end

  # PATCH/PUT organizations/:organization_id/c/:campaign_id/posts/:post_id/comments/:id
  # PATCH/PUT organizations/:organization_id/c/:campaign_id/posts/:post_id/comments/:id.json
  def update
    respond_to do |format|
      if comment_params.present? && @comment.update(comment_params)
        format.js
      else
        format.js { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_comment
      @comment = @post.comments.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:flagged)
    end
end

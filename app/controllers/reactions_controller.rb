class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_campaign
  before_action :set_post
  before_action :set_reaction, only: [:update]

  def index
    respond_to do |format|
      format.html
      format.json { render json: ReactionsDatatable.new(view_context, @post) }
    end
  end

  # PATCH/PUT organizations/:organization_id/c/:campaign_id/posts/:post_id/reactions/:id
  # PATCH/PUT organizations/:organization_id/c/:campaign_id/posts/:post_id/reactions/:id.json
  def update
    @reaction.flagged = !@reaction.flagged
    respond_to do |format|
      if @reaction.save
        format.js
      else
        format.js { render json: @reaction.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_reaction
      @reaction = @post.reactions.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reaction_params
      params.require(:reaction).permit(:flagged)
    end
end

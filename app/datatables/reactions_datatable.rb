class ReactionsDatatable < Datatable

  def as_json(options = {})
    {
      draw: params[:draw].to_i,
      recordsTotal: @post.reactions.count,
      recordsFiltered: reactions.total_count,
      data: data
      #add error message https://datatables.net/manual/server-side#Returned-data
    }
  end

private

  def data
    reactions.map do |reaction|
      {
        category: reaction.category.downcase,
        user: {
          name: reaction.network_user_name,
          url: @post.network.user_link(reaction.network_user_id)
        },
        flagged: {
          id: reaction.id,
          status: reaction.flagged,
          url: organization_campaign_post_reaction_path(@organization, @campaign, @post, reaction, reaction: { flagged: !reaction.flagged })
        }
      }
    end
  end

  def reactions
    @reactions ||= fetch_reactions
  end

  def fetch_reactions
    reactions = @post.reactions.order("#{sort_column} #{sort_direction}")
    reactions = reactions.page(page).per(per_page)
    if params[:search].present?
      reactions = reactions.where("LOWER(network_user_name) like :search or LOWER(category) like :search", search: "%#{params[:search].try(:[], :value).downcase}%")
    end
    reactions
  end

  def sort_column
    columns = %w[category network_user_name flagged]
    columns[params[:order].try(:[], "0").try(:[], :column).to_i]
  end
end

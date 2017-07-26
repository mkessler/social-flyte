class FlaggedInteractionsDatatable < Datatable

  #Override default to handle both Campaign and Post
  def initialize(view, parent)
    @view = view
    @parent = parent
  end

  def as_json(options = {})
    {
      draw: params[:draw].to_i,
      recordsTotal: @parent.flagged_interactions.count,
      recordsFiltered: flagged_interactions.total_count,
      data: data
      #add error message https://datatables.net/manual/server-side#Returned-data
    }
  end

  private

  def data
    flagged_interactions.map do |flagged_interaction|
      {
        network: flagged_interaction.post.network.slug,
        class: flagged_interaction.class.name,
        user: {
          name: flagged_interaction.network_user_name,
          url: flagged_interaction.post.network.user_link(flagged_interaction.network_user_id)
        },
        content: {},
        post_name: flagged_interaction.post.name.truncate(64),
        posted_at: {
          time: flagged_interaction.try(:posted_at) ? flagged_interaction.posted_at.strftime('%l:%M%P') : 'Not Available',
          date: flagged_interaction.try(:posted_at) ? flagged_interaction.posted_at.strftime('%b %-d %Y') : 'Not Available'
        },
        flagged: {
          id: flagged_interaction.id,
          status: flagged_interaction.flagged
        }
      }.tap do |hash|
        if flagged_interaction.is_a?(Comment)
          hash[:content][:attachment] = {
            image: flagged_interaction.attachment_image,
            url: flagged_interaction.attachment_url
          }
          hash[:content][:message] = flagged_interaction.message
          hash[:flagged][:url] = organization_campaign_post_comment_path(
            flagged_interaction.post.campaign.organization,
            flagged_interaction.post.campaign,
            flagged_interaction.post,
            flagged_interaction,
            comment: {
              flagged: !flagged_interaction.flagged
            }
          )
        end
        if flagged_interaction.is_a?(Reaction)
          hash[:content][:category] = flagged_interaction.category.downcase
          hash[:flagged][:url] = organization_campaign_post_reaction_path(
            flagged_interaction.post.campaign.organization,
            flagged_interaction.post.campaign,
            flagged_interaction.post,
            flagged_interaction,
            reaction: {
              flagged: !flagged_interaction.flagged
            }
          )
        end
        if flagged_interaction.is_a?(Share)
          hash[:content][:share_link] = "https://facebook.com/#{flagged_interaction.network_share_id}"
          hash[:flagged][:url] = organization_campaign_post_share_path(
            flagged_interaction.post.campaign.organization,
            flagged_interaction.post.campaign,
            flagged_interaction.post,
            flagged_interaction,
            share: {
              flagged: !flagged_interaction.flagged
            }
          )
        end
      end
    end
  end

  def flagged_interactions
    @flagged_interactions ||= fetch_flagged_interactions
  end

  def fetch_flagged_interactions
    if sort_column == "network"
      flagged_interactions = @parent.flagged_interactions.sort_by {|i| i.post.network.slug}
    elsif sort_column == "class"
      flagged_interactions = @parent.flagged_interactions.sort_by {|i| i.class.name}
    elsif sort_column == "content"
      flagged_interactions = @parent.flagged_interactions.sort_by {|i| i.try(:message) || i.try(:category)}
    elsif sort_column == "post_name"
      flagged_interactions = @parent.flagged_interactions.sort_by {|i| i.post.name}
    elsif sort_column == "posted_at"
      flagged_interactions = @parent.flagged_interactions.select(&sort_column.to_sym).sort_by(&sort_column.to_sym) + @parent.flagged_interactions.reject(&sort_column.to_sym)
    else
      flagged_interactions = @parent.flagged_interactions.sort_by(&sort_column.to_sym)
    end
    flagged_interactions = flagged_interactions.reverse if sort_direction == 'desc'
    flagged_interactions = Kaminari.paginate_array(flagged_interactions).page(page).per(per_page)
    flagged_interactions
  end

  def sort_column
    columns = %w[post_name class network_user_name content posted_at]
    columns[params[:order].try(:[], "0").try(:[], :column).to_i]
  end
end

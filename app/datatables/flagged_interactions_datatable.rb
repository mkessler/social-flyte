class FlaggedInteractionsDatatable < Datatable

  def as_json(options = {})
    {
      draw: params[:draw].to_i,
      recordsTotal: @campaign.flagged_interactions.count,
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
        user: {
          name: flagged_interaction.network_user_name,
          url: flagged_interaction.post.network.user_link(flagged_interaction.network_user_id)
        },
        type: flagged_interaction.class.name
      }
    end
  end

  def flagged_interactions
    @flagged_interactions ||= fetch_flagged_interactions
  end

  def fetch_flagged_interactions
    if sort_column.present?
      flagged_interactions = @campaign.flagged_interactions.sort_by(&:"#{sort_column}")
    else
      flagged_interactions = @campaign.flagged_interactions
    end
    flagged_interactions = flagged_interactions.reverse if sort_direction === 'desc'
    flagged_interactions = Kaminari.paginate_array(flagged_interactions).page(page).per(per_page)
    # if params[:search].present?
    #   flagged_interactions = flagged_interactions.where("LOWER(network_user_name) like :search", search: "%#{params[:search].try(:[], :value).downcase}%")
    # end
    flagged_interactions
  end

  def sort_column
    columns = %w[network network_user_name type]
    columns[params[:order].try(:[], "0").try(:[], :column).to_i]
  end
end

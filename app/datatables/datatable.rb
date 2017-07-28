class Datatable
  include Rails.application.routes.url_helpers
  delegate :params, to: :@view

  def initialize(view, post)
    @view = view
    @post = post
  end

  private

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 5
  end

  def sort_direction
    params[:order].try(:[], "0").try(:[], :dir) == "desc" ? "desc" : "asc"
  end
end

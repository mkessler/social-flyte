module PostsHelper
  def comments_active_class
    'active' if params[:reactions_page].nil?
  end

  def reactions_active_class
    'active' if params[:reactions_page].present?
  end
end

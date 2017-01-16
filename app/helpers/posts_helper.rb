module PostsHelper
  def synced_at_formatted(date)
    date.present? ? date.strftime('%b %-d, %Y %l:%M%p') : 'Never'
  end
end

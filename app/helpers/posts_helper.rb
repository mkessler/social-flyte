module PostsHelper
  def synced_at_formatted(date)
    date.present? ? date.strftime('%b %-d, %Y %l:%M%P %Z') : 'Never'
  end
end

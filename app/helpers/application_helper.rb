# Application Helper
module ApplicationHelper
  def icons_meta_tags
    '<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
    <link rel="icon" type="image/png" href="/favicon-32x32.png" sizes="32x32">
    <link rel="icon" type="image/png" href="/favicon-16x16.png" sizes="16x16">
    <link rel="manifest" href="/manifest.json">
    <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5">
    <meta name="theme-color" content="#ffffff">'.html_safe
  end

  def sidenav_active_class(controllers=[], action=nil)
    active = false
    if controllers.present? && action.present?
      active = controllers.include?(params[:controller]) && action == params[:action]
    elsif controllers.present?
      active = controllers.include?(params[:controller])
    elsif action.present?
      active = action == params[:action]
    end

    active ? 'active' : ''
  end
end

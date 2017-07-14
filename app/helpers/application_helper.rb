# Application Helper
module ApplicationHelper
  def app_meta_tags
    '<meta name="google-site-verification" content="W4IBXqiBX_4P7c60rNXv3Ij9On6yw5HhY7TGZB-CmrQ" />'.html_safe
  end

  def icons_meta_tags
    '<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png">
    <link rel="manifest" href="/manifest.json">
    <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5">
    <meta name="apple-mobile-web-app-title" content="SocialFlyte">
    <meta name="application-name" content="SocialFlyte">
    <meta name="theme-color" content="#ffffff">'.html_safe
  end
end

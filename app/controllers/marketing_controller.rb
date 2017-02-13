# Marketing Controller
class MarketingController < ApplicationController
  def index
    set_meta_tags site: meta_title('Native Social Promotion Platform')
  end
end

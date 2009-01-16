class Admin::ConfigurationsController < Admin::BaseController
  before_filter :add_search_link, :only => :index

  def add_search_link
    @extension_links << {
      :link =>  '#' ,
      :link_text => Globalite.localize(:ext_search),
      :description => Globalite.localize(:ext_search_description)
    }
  end
end

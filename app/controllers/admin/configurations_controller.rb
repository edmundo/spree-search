class Admin::ConfigurationsController < Admin::BaseController
  before_filter :add_search_link, :only => :index

  def add_search_link
    @extension_links << {
      :link => '#' ,
      :link_text => t('ext.search.extension_name'),
      :description => t('ext.search.extension_description')
    }
  end
end

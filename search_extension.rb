# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class SearchExtension < Spree::Extension
  version "1.0"
  description "Search and sort extension for spree."
  url "http://yourwebsite.com/search"

  # Testing route.
  define_routes do |map|
    map.search_test '/search/test', :controller => 'searches', :action => 'test'
  end

  define_routes do |map|
    map.resources :searches
  end

  def activate
    # Add pagination support for the find_by_sql method inside paginating_find plugin.
    PaginatingFind::ClassMethods.class_eval do
      def paginating_sql_find(count_query, query, options)

        # The current page defaults to 1 when not passed.
        options[:current] ||= "1"

        count_query = sanitize_sql(count_query)
        query = sanitize_sql(query)
   
        # execute the count query - need to know how many records we're looking at   
        count = count_by_sql(count_query)
   
        PagingEnumerator.new(options[:page_size], count, false, options[:current], 1) do |page|
          # calculate the right offset values for current page and page_size
            offset = (options[:current].to_i - 1) * options[:page_size]
            limit = options[:page_size]
   
            # run the actual query - Note: do not include LIMIT statement in your query          
          find_by_sql(query + " LIMIT #{offset},#{limit}")
        end
      end
    end

#    ProductsController.class_eval do
#      private
#      
#      def collection
#        if params[:order_by]
#          order_by = params[:order_by]
#          ["master_price", "name", "available_on"].include?(params[:order_by]) || order_by = "name"
#        end
#      
#        order_by ||= "name"
#        
#        if params[:side]
#          side = params[:side]
#          ["asc", "desc"].include?(params[:side]) || side = "asc"
#        end
#      
#        side ||= "asc"
#    
#        if params[:search]
#          @search_param = "- #{:searching_by.l_with_args({ :search_term => params[:search] })}"
#          @collection ||= Product.available.by_name(params[:search]).find(
#            :all,
#            :order => "#{order_by} #{side}",
#            :page => {:start => 1, :size => 4, :current => params[:p]}, 
#            :include => :images)
#        else
#          @search_param = ""
#          @collection ||= Product.available.find(
#            :all,
#            :order => "#{order_by} #{side}",
#            :page => {:start => 1, :size => 4, :current => params[:p]},
#            :include => :images)
#        end
#      end
#    end
#
#    TaxonsController.class_eval do
#      private
#      
#      def load_data
#        if params[:order_by]
#          order_by = params[:order_by]
#          ["master_price", "name", "available_on"].include?(params[:order_by]) || order_by = "name"
#        end
#      
#        order_by ||= "name"
#        
#        if params[:side]
#          side = params[:side]
#          ["asc", "desc"].include?(params[:side]) || side = "asc"
#        end
#      
#        side ||= "asc"
#    
#        if params[:search]
#          @search_param = "- #{:searching_by.l_with_args({ :search_term => params[:search] })}"
#          @products ||= object.products.available.by_name(params[:search]).find(
#            :all,
#            :order => "#{order_by} #{side}",
#            :page => {:start => 1, :size => 4, :current => params[:p]},
#            :include => :images)
#        else
#          @search_param = ""
#          @products ||= object.products.available.find(
#            :all,
#            :order => "#{order_by} #{side}",
#            :page => {:start => 1, :size => 4, :current => params[:p]},
#            :include => :images)
#        end
#    
#        @product_cols = 3
#      end
#    end

    # Add support for internationalization to this extension.
    Globalite.add_localization_source(File.join(RAILS_ROOT, 'vendor/extensions/search/lang/ui'))

    # Add the administration link. (Only as a placeholder)
    Admin::ConfigurationsController.class_eval do
      before_filter :add_search_link, :only => :index
      def add_search_link
        @extension_links << {:link =>  '#' , :link_text => Globalite.localize(:ext_search), :description => Globalite.localize(:ext_search_description)}
      end
    end
    # admin.tabs.add "Search", "/admin/search", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Search"
  end

  def self.require_gems(config)
    config.gem 'activerecord-tableless', :lib => 'tableless'
  end
end
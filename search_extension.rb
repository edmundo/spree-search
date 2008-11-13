# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class SearchExtension < Spree::Extension
  version "0.1"
  description "Search and sort extension for spree."
  url "http://github.com/edmundo/spree-search/tree/master"

  # Testing route.
  define_routes do |map|
    map.search_test '/search/test', :controller => 'searches', :action => 'test'
  end

  define_routes do |map|
    map.resources :searches
  end

  def activate
# Uncomment those methods to make the simple search work for products and inside taxons
#    ProductsController.class_eval do
#      private
#      
#      def collection
#        products_per_page = 20
#
#        search = Search.new({
#          :taxon_id => params[:taxon],
#          :min_price => params[:min_price],
#          :max_price => params[:max_price],
#          :keywords => params[:search]
#        })
#        # Verify if theres any ondition.
#        conditions = search.conditions
#        if conditions == [""]
#          conditions = ""
#        end
#    
#        # Define what is allowed.
#        sort_params = {
#          "price_asc" => "master_price ASC",
#          "price_desc" => "master_price DESC",
#          "date_asc" => "available_on ASC",
#          "date_desc" => "available_on DESC",
#          "name_asc" => "name ASC",
#          "name_desc" => "name DESC"
#        }
#        # Set it to what is allowed or default.
#        @sort_by = sort_params[params[:sort]] || "available_on DESC"
#        
#        @search_param = "- #{:searching_by.l_with_args({ :search_term => params[:search] })}" if params[:search]
#        
#        @collection ||= Product.available.by_name(params[:search]).find(
#          :all,
#          :conditions => conditions,
#          :order => @sort_by,
#          :page => {:start => 1, :size => products_per_page, :current => params[:p]},
#          :include => :images)
#      end
#    end
#
#    TaxonsController.class_eval do
#      private
#      
#      def load_data
#        products_per_page = 20
#    
#        search = Search.new({
#          :taxon_id => params[:taxon],
#          :min_price => params[:min_price],
#          :max_price => params[:max_price],
#          :keywords => params[:search]
#        })
#        # Verify if theres any ondition.
#        conditions = search.conditions
#        if conditions == [""]
#          conditions = ""
#        end
#    
#        # Define what is allowed.
#        sort_params = {
#          "price_asc" => "master_price ASC",
#          "price_desc" => "master_price DESC",
#          "date_asc" => "available_on ASC",
#          "date_desc" => "available_on DESC",
#          "name_asc" => "name ASC",
#          "name_desc" => "name DESC"
#        }
#        # Set it to what is allowed or default.
#        @sort_by = sort_params[params[:sort]] || "available_on DESC"
#        
#        @search_param = "- #{:searching_by.l_with_args({ :search_term => params[:search] })}" if params[:search]
#        
#        @products ||= object.products.available.by_name(params[:search]).find(
#          :all,
#          :conditions => conditions,
#          :order => @sort_by,
#          :page => {:start => 1, :size => products_per_page, :current => params[:p]},
#          :include => :images)
#      end
#    end
    
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

    # Add support for internationalization to this extension.
    Globalite.add_localization_source(File.join(RAILS_ROOT, 'vendor/extensions/search/lang/ui'))

    # Add the administration link. (Only as a placeholder)
    Admin::ConfigurationsController.class_eval do
      before_filter :add_search_link, :only => :index
      def add_search_link
        @extension_links << {:link =>  '#' , :link_text => Globalite.localize(:ext_search), :description => Globalite.localize(:ext_search_description)}
      end
    end
  end
  
  def self.require_gems(config)
    config.gem 'activerecord-tableless', :lib => 'tableless'
  end
end
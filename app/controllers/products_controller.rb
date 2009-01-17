class ProductsController < Spree::BaseController
# Uncomment those methods to make the simple search work for products and inside taxons
      private

      def collection
        products_per_page = 20

        search = Search.new({
          :taxon_id => params[:taxon],
          :min_price => params[:min_price],
          :max_price => params[:max_price],
          :keywords => params[:search]
        })
        # Verify if theres any ondition.
        conditions = search.conditions
        if conditions == [""]
          conditions = ""
        end

        # Define what is allowed.
        sort_params = {
          "price_asc" => "master_price ASC",
          "price_desc" => "master_price DESC",
          "date_asc" => "available_on ASC",
          "date_desc" => "available_on DESC",
          "name_asc" => "name ASC",
          "name_desc" => "name DESC"
        }
        # Set it to what is allowed or default.
        @sort_by = sort_params[params[:sort]] || "available_on DESC"

        @search_param = "- #{t('ext.search.searching_by', :search_term => params[:search])}" if params[:search]

        @collection ||= Product.active.by_name(params[:search]).find(
          :all,
          :conditions => conditions,
          :order => @sort_by,
          :page => {:start => 1, :size => products_per_page, :current => params[:p]},
          :include => :images)
      end
    end

    TaxonsController.class_eval do
      private

      def load_data
        products_per_page = 20

        search = Search.new({
          :taxon_id => params[:taxon],
          :min_price => params[:min_price],
          :max_price => params[:max_price],
          :keywords => params[:search]
        })
        # Verify if theres any ondition.
        conditions = search.conditions
        if conditions == [""]
          conditions = ""
        end

        # Define what is allowed.
        sort_params = {
          "price_asc" => "master_price ASC",
          "price_desc" => "master_price DESC",
          "date_asc" => "available_on ASC",
          "date_desc" => "available_on DESC",
          "name_asc" => "name ASC",
          "name_desc" => "name DESC"
        }
        # Set it to what is allowed or default.
        @sort_by = sort_params[params[:sort]] || "available_on DESC"

        @search_param = "- #{t('ext.search.searching_by', :search_term => params[:search])}" if params[:search]

        @products ||= object.products.active.by_name(params[:search]).find(
          :all,
          :conditions => conditions,
          :order => @sort_by,
          :page => {:start => 1, :size => products_per_page, :current => params[:p]},
          :include => :images)
      end
end

class TaxonsController < Spree::BaseController
  private

# Uncomment this method to make the simple search work inside taxons.
#  def load_data
#    # Define what is allowed.
#    sort_params = {
#      "price_asc" => ["master_price", "ASC"],
#      "price_desc" => ["master_price", "DESC"],
#      "date_asc" => ["available_on", "ASC"],
#      "date_desc" => ["available_on", "DESC"],
#      "name_asc" => ["name", "ASC"],
#      "name_desc" => ["name", "DESC"]
#    }
#    # Set it to what is allowed or default.
#    @sort_by_and_as = sort_params[params[:sort]] || ["available_on", "DESC"]
#    # If setted to default, clean the param it doesn't need to clutter the url.
#    params[:sort] = nil if @sort_by_and_as == ["available_on", "DESC"]
#
##    @search_param = "- #{t('ext.search.searching_by', :search_term => params[:keywords])}" if params[:keywords]
#
#    @search = object.products.active.new_search(params[:search])
#    @search.order_by = @sort_by_and_as[0]
#    @search.order_as = @sort_by_and_as[1]
#    @search.conditions.name_contains = params[:keywords]
#
#    @search.per_page = Spree::Config[:products_per_page]
#    @search.include = :images
#
#    @product_cols = 3
#    @products ||= @search.all
#  end
end

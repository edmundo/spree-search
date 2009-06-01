class SearchesController < Spree::BaseController
  layout 'application'
  helper :taxons, :products

  def test
  end
  
  # Create a search object to receive parameters of the form to validate.
  def new
    @search = Search.new
  end
  
  # Validates the search object and redirect to show action renaming the parameters to not clash with searchlogic.
  def create
    @search = Search.new(params[:search])
    if @search.valid?

      # Build the custom parameters hash and don't clutter the url with empty params.
      temp = {}
      temp.merge!(:taxon => params["search"]["taxon_id"]) if !params["search"]["taxon_id"].empty?
      temp.merge!(:subtaxons => params["search"]["subtaxons"]) if params["search"]["subtaxons"] == "1"
      temp.merge!(:min_price => params["search"]["min_price"]) if !params["search"]["min_price"].empty?
      temp.merge!(:max_price => params["search"]["max_price"]) if !params["search"]["max_price"].empty?
      temp.merge!(:keywords => params["search"]["keywords"]) if !params["search"]["keywords"].empty?

      redirect_to temp.merge(:action => 'show')
    else
      render :action => 'new'
    end
  end
  
  def show
    # Define what is allowed.
    sort_params = {
      "price_asc" => ["master_price", "ASC"],
      "price_desc" => ["master_price", "DESC"],
      "date_asc" => ["available_on", "ASC"],
      "date_desc" => ["available_on", "DESC"],
      "name_asc" => ["name", "ASC"],
      "name_desc" => ["name", "DESC"]
    }
    # Set it to what is allowed or default.
    @sort_by_and_as = sort_params[params[:sort]] || ["available_on", "DESC"]
    # If setted to default, clean the param it doesn't need to clutter the url.
    params[:sort] = nil if @sort_by_and_as == ["available_on", "DESC"]

    @search = Product.active.new_search(params[:search])

    if params[:taxon]
      if params[:subtaxons]
        an_array = []

        a_taxon = Taxon.first(:conditions => {:id_is => params[:taxon]})
        add_subtaxons(an_array, a_taxon) if a_taxon

        @search.conditions.taxons.id_equals = an_array
      else
        @search.conditions.taxons.id_equals = params[:taxon]
      end
    end


    @search.order_by = @sort_by_and_as[0]
    @search.order_as = @sort_by_and_as[1]
    @search.conditions.name_contains = params[:keywords]
    @search.conditions.master_price_greater_than_or_equal_to = params[:min_price]
    @search.conditions.master_price_less_than_or_equal_to = params[:max_price]
    @search.per_page = Spree::Config[:products_per_page]
    @search.include = :images

    @product_cols = 3
    @products ||= @search.all
end


  private
  
  def add_subtaxons(taxon_array, taxon)
    taxon_array << taxon.id
    taxon.children.each do |subtaxon|
      add_subtaxons(taxon_array, subtaxon)
    end
  end

end

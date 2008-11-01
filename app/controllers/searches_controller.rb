class SearchesController < Admin::BaseController
  layout 'application'
  helper :taxons, :products

  def test
  end
  
  def new
    @search = Search.new
  end
  
  def create
    @search = Search.new(params[:search])
#    if @search.valid?
      
      # Build the custom parameters hash and don't clutter the url with empty params.
      temp = {}
      temp.merge!(:taxon => params["search"]["taxon_id"]) if !params["search"]["taxon_id"].empty?
      temp.merge!(:min_price => params["search"]["minimum_price"]) if !params["search"]["minimum_price"].empty?
      temp.merge!(:max_price => params["search"]["maximum_price"]) if !params["search"]["maximum_price"].empty?
      temp.merge!(:keywords => params["search"]["keywords"]) if !params["search"]["keywords"].empty?
      
      redirect_to temp.merge(:action => 'show')
#    else
#      render :action => 'new'
#    end
  end
  
  def show
    products_per_page = 4

    @search = Search.new({
      :taxon_id => params[:taxon],
      :minimum_price => params[:min_price],
      :maximum_price => params[:max_price],
      :keywords => params[:keywords]
    })
    # Verify if theres any ondition.
    conditions = @search.conditions
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
    
    @search_param = "- #{:searching_by.l_with_args({ :search_term => params[:search] })}" if params[:search]
    
    if @search.taxon_id
      @products ||= Taxon.find(@search.taxon_id).products.available.find(
        :all,
        :conditions => conditions,
        :order => @sort_by,
        :page => {:start => 1, :size => products_per_page, :current => params[:p]},
        :include => :images)
    else
      @products ||= Product.available.by_name(params[:search]).find(
        :all,
        :conditions => conditions,
        :order => @sort_by,
        :page => {:start => 1, :size => products_per_page, :current => params[:p]},
        :include => :images)
    end
  end

end

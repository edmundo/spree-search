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
    if @search.valid?
      
      # Build the custom parameters hash and don't clutter the url with empty params.
      temp = {}
      temp.merge!(:taxon => params["search"]["taxon_id"]) if !params["search"]["taxon_id"].empty?
      temp.merge!(:include_subtaxons => params["search"]["include_subtaxons"]) if !params["search"]["include_subtaxons"].empty?
      temp.merge!(:min_price => params["search"]["minimum_price"]) if !params["search"]["minimum_price"].empty?
      temp.merge!(:max_price => params["search"]["maximum_price"]) if !params["search"]["maximum_price"].empty?
      temp.merge!(:keywords => params["search"]["keywords"]) if !params["search"]["keywords"].empty?
      
      redirect_to temp.merge(:action => 'show')
    else
      render :action => 'new'
    end
  end
  
  def show
    products_per_page = 4

    @search = Search.new({
      :taxon_id => params[:taxon],
      :include_subtaxons => params[:include_subtaxons],
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
    
    an_array = []
    add_subtaxons(an_array, Taxon.find(@search.taxon_id)) if @search.taxon_id
    
    count_query = "
      SELECT count(products.id) FROM products
      INNER JOIN products_taxons ON (products.id = products_taxons.product_id)
      INNER JOIN taxons ON (products_taxons.taxon_id = taxons.id)
      WHERE taxons.id IN (#{an_array.join(',').to_s})
      #{(conditions.empty? ? "" : " AND ")} #{conditions}"
            
    query = "
      SELECT products.* FROM products
      INNER JOIN products_taxons ON (products.id = products_taxons.product_id)
      INNER JOIN taxons ON (products_taxons.taxon_id = taxons.id)
      WHERE taxons.id IN (#{an_array.join(',').to_s})
      #{(conditions.empty? ? "" : " AND ")} #{conditions} ORDER BY #{@sort_by}"
 
 
    if @search.include_subtaxons
      @products ||= Product.paginating_sql_find(
        count_query, query, {:page_size => products_per_page, :current => params[:p]}
      )
    elsif @search.taxon_id
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


  private
  
  def add_subtaxons(taxon_array, taxon)
    taxon_array << taxon.id
    taxon.children.each do |subtaxon|
      add_subtaxons(taxon_array, subtaxon)
    end
  end

end

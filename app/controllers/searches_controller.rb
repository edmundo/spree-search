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
    if @search.save
      redirect_to @search
    else
      render :action => 'new'
    end
  end
  
  def show
    products_per_page = 20
    @search = Search.find(params[:id])

    if params[:order_by]
      order_by = params[:order_by]
      ["master_price", "name", "available_on"].include?(params[:order_by]) || order_by = "name"
    end
  
    order_by ||= "name"
    
    if params[:side]
      side = params[:side]
      ["asc", "desc"].include?(params[:side]) || side = "asc"
    end
  
    side ||= "asc"

    if params[:search]
      @search_param = "- #{:searching_by.l_with_args({ :search_term => params[:search] })}"
      @products ||= Product.available.by_name(params[:search]).find(
        :all,
        :conditions => @search.conditions,
        :order => "#{order_by} #{side}",
        :page => {:start => 1, :size => products_per_page, :current => params[:p]},
        :include => :images)
    elsif @search.taxon_id
      @search_param = ""
      conditions = @search.conditions
      if conditions == [""]
        conditions = ""
      end
        @products ||= Taxon.find(@search.taxon_id).products.available.find(
          :all,
          :conditions => conditions,
          :order => "#{order_by} #{side}",
          :page => {:start => 1, :size => products_per_page, :current => params[:p]},
          :include => :images)
    else
      @search_param = ""
      @products ||= Product.available.find(
        :all,
        :conditions => @search.conditions,
        :order => "#{order_by} #{side}",
        :page => {:start => 1, :size => products_per_page, :current => params[:p]},
        :include => :images)
    end
  end

end

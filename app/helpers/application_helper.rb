# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Helper to maintain used search params to not clutter the url.
  def maintain_search_params
    search_params = {}
    search_params.merge!(:taxon => params[:taxon]) if !params[:taxon].nil? && !params[:taxon].empty?
    search_params.merge!(:subtaxons => params[:subtaxons]) if params[:subtaxons] != "0"
    search_params.merge!(:min_price => params[:min_price]) if !params[:min_price].nil? && !params[:min_price].empty?
    search_params.merge!(:max_price => params[:max_price]) if !params[:max_price].nil? && !params[:max_price].empty?
    search_params.merge!(:keywords => params[:keywords]) if !params[:keywords].nil? && !params[:keywords].empty?
    search_params.merge!(:sort => params[:sort]) if !params[:sort].nil? && !params[:sort].empty?
    search_params.merge!(:search => params[:search]) if !params[:search].nil? && !params[:search].empty?

    search_params
  end

end

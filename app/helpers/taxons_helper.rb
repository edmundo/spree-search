module TaxonsHelper
  # Odd. The product search is made inside a helper when the taxon has children. So we change the helper
  # to filter every taxon contents that will be collected to sum up what will be on the preview.
  def taxon_preview(taxon)
    a_search = taxon.products.active.new_search(params[:search])
    a_search.conditions.name_contains = params[:keywords]
    products = a_search.all[0..4]

#    products = taxon.products.active[0..4]
    return products unless products.size < 5
    if Spree::Config[:show_descendents]
      taxon.descendents.each do |taxon|
        another_search = taxon.products.active.new_search(params[:search])
        another_search.conditions.name_contains = params[:keywords]
        products += another_search.all[0..4]

#        products += taxon.products.active[0..4]
        break if products.size >= 5
      end
    end
    products[0..4]
  end
end
class Search < ActiveRecord::Base

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end
    
  private
    
    def keyword_conditions
      ["products.name LIKE ?", "%#{keywords}%"] unless keywords.blank?
    end
    
    def minimum_price_conditions
      ["products.master_price >= ?", minimum_price] unless minimum_price.blank?
    end
    
    def maximum_price_conditions
      ["products.master_price <= ?", maximum_price] unless maximum_price.blank?
    end
    
    def conditions_clauses
      conditions_parts.map { |condition| condition.first }
    end
    
    def conditions_options
      conditions_parts.map { |condition| condition[1..-1] }.flatten
    end
    
    def conditions_parts
      private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
    end


end

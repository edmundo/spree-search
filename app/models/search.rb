class Search < ActiveRecord::Base
  has_no_table

  column :keywords, :string
  column :taxon_id, :integer
  column :min_price, :float
  column :max_price, :float
  column :subtaxons, :boolean

  validates_numericality_of :min_price, :unless => Proc.new { |search| search.min_price.nil? }
  validates_numericality_of :max_price, :unless => Proc.new { |search| search.max_price.nil? }
  
  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end
    
  private
    
    def keyword_conditions
      ["products.name LIKE ?", "%#{keywords}%"] unless keywords.blank?
    end
    
    def min_price_conditions
      ["products.master_price >= ?", min_price] unless min_price.blank?
    end
    
    def max_price_conditions
      ["products.master_price <= ?", max_price] unless max_price.blank?
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

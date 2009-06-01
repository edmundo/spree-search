class Search < ActiveRecord::Base
  has_no_table

  column :keywords, :string
  column :taxon_id, :integer
  column :min_price, :float
  column :max_price, :float
  column :subtaxons, :boolean

  validates_numericality_of :min_price, :unless => Proc.new { |search| search.min_price.nil? }
  validates_numericality_of :max_price, :unless => Proc.new { |search| search.max_price.nil? }
end

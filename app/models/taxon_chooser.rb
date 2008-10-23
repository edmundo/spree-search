class TaxonChooser
  TaxonOption = Struct.new(:id, :name)
  
  class TaxonType
    attr_reader :type_name, :options
    
    def initialize(name)
      @type_name = name
      @options = []
    end
    
    def <<(option)
      @options << option
    end
  end
  
  OPTIONS = []
  
  taxonomies = Taxonomy.find(:all, :include => {:root => :children})
  taxonomies.each do |taxonomy|
    a_taxonomy = TaxonType.new(taxonomy.root.name)
    taxonomy.root.children.each do |taxon|
      a_taxonomy <<  TaxonOption.new(taxon.id, taxon.name)
    end
    OPTIONS << a_taxonomy
  end
end

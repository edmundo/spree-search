class TaxonChooser

  class TaxonOption
    attr_reader :id, :name

    def initialize(id, name)
      @id = id
      @name = name
    end
  end
  
  class TaxonType
    attr_reader :type_name, :options
    
    def initialize(name)
      @type_name = name
      @options = []
    end
    
    def <<(option)
      @options << option
    end
    
    def populate(taxonomy)
      taxonomy.root.children.each do |taxon|
        self.include_taxon_tree(taxonomy, taxon, 0)
      end
    end

    def include_taxon_tree(taxonomy, taxon, level)
      self <<  TaxonOption.new(taxon.id, "&nbsp;" * level * 4 + taxon.name)
      taxon.children.each do |subtaxon|
        include_taxon_tree(taxonomy, subtaxon, level + 1)
      end
    end

  end
  
  OPTIONS = []
  
  taxonomies = Taxonomy.find(:all, :include => {:root => :children})
  taxonomies.each do |taxonomy|
    a_taxonomy = TaxonType.new(taxonomy.root.name)
    a_taxonomy.populate(taxonomy)
    OPTIONS << a_taxonomy
  end
  
end

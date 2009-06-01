# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'

class SearchExtension < Spree::Extension
  version "0.99"
  description "Search and sort extension for spree."
  url "http://github.com/edmundo/spree-search/tree/master"

  def activate
    
#    # Add pagination support for the find_by_sql method inside paginating_find plugin.
#    PaginatingFind::ClassMethods.class_eval do
#      def paginating_sql_find(count_query, query, options)
#
#        # The current page defaults to 1 when not passed.
#        options[:current] ||= "1"
#
#        count_query = sanitize_sql(count_query)
#        query = sanitize_sql(query)
#
#        # execute the count query - need to know how many records we're looking at
#        count = count_by_sql(count_query)
#
#        PagingEnumerator.new(options[:page_size], count, false, options[:current], 1) do |page|
#          # calculate the right offset values for current page and page_size
#            offset = (options[:current].to_i - 1) * options[:page_size]
#            limit = options[:page_size]
#
#            # run the actual query - Note: do not include LIMIT statement in your query
#          find_by_sql(query + " LIMIT #{offset},#{limit}")
#        end
#      end
#    end
  end
  
  def self.require_gems(config)
    config.gem 'activerecord-tableless', :lib => 'tableless'
  end
end
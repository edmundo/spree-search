require File.dirname(__FILE__) + '/../spec_helper'

module SearchSpecHelper
  def valid_search_attributes
    {
      :keywords => "keyword",
      :taxon_id => "2000",
      :min_price => "1",
      :max_price => "100",
      :subtaxons => "1"
    }
  end
end


describe Search do
  include SearchSpecHelper

  before(:each) do
    @search = Search.new
  end

  ['min_price', 'max_price'].each do |field|
    it "should not accept non number values in the #{field} field" do
      @search.send("#{field}=", "a")
      @search.should_not be_valid
      @search.errors.full_messages.should include("#{field.intern.l(field).humanize} #{:error_message_not_a_number.l}")
    end
  end

  ['min_price', 'max_price'].each do |field|
    it "should accept integer values in the #{field} field" do
      @search.send("#{field}=", "1")
      @search.should be_valid
    end
  end
  
  ['min_price', 'max_price'].each do |field|
    it "should accept float point values in the #{field} field" do
      @search.send("#{field}=", "1.2")
      @search.should be_valid
    end
  end

  it "should be valid when having correct information" do
    @search.attributes = valid_search_attributes
    @search.should be_valid
  end

  it "should not return any SQL fragment when the fields are blank" do
    @search.attributes = {
      :keywords => "",
      :taxon_id => "",
      :min_price => "",
      :max_price => "",
      :subtaxons => "0"
    }
    @search.conditions.should == [""]
  end

  it "should return an SQL fragment with the keyword when requested to" do
    a_keyword = "a_keyword"
    @search.keywords = a_keyword
    @search.conditions.should == ["products.name LIKE ?", "%#{a_keyword}%"]
  end

  it "should return an SQL fragment with the min_price when requested to" do
    a_min_price = "1"
    @search.min_price = a_min_price
    @search.conditions.should == ["products.master_price >= ?", a_min_price.to_f]
  end

  it "should return an SQL fragment with the max_price when requested to" do
    a_max_price = "20"
    @search.max_price = a_max_price
    @search.conditions.should == ["products.master_price <= ?", a_max_price.to_f]
  end

end

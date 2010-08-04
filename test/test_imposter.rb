require 'helper'

class TestImposter < Test::Unit::TestCase
  
  context "gen_models generator" do
    
    context "setup"
    
      # setup do
      #   @user = User.find(:first)
      # end
      
      should "read a YAML config file and set instance variables accordingly"
      
    end
  end
  
  
  should "produce a legal URL on request" do
    assert_match(%r{http://.+\.\w+}, Imposter.urlify())
  end
  
  should "allow user to specify URL's protocol, subdomain, TLD, port number, path, params, etc"
  
  should "provide a single, scalar word from nouns collection" do
    assert_equal "String", Imposter::Noun.one.class.name
  end
  
  should "provide a single, scalar word from animals collection" do
    assert_equal "String", Imposter::Animal.one.class.name
  end
  
  should "provide a single, scalar word from minerals collection" do
    assert_equal "String", Imposter::Mineral.one.class.name
  end
  
  should "provide a single, scalar word from vegetables collection" do
    assert_equal "String", Imposter::Vegetable.one.class.name
  end
  
  should "provide a single, scalar word from verbs collection" do
    assert_equal "String", Imposter::Verb.one.class.name
  end
  
  should "provide multiple words from nouns collection" do
    assert_equal "String", Imposter::Noun.multiple(4).class.name
  end
  
  should "provide multiple words from animals collection" do
    assert_equal "String", Imposter::Animal.multiple(4).class.name
  end
  
  should "provide multiple words from minerals collection" do
    assert_equal "String", Imposter::Mineral.multiple(4).class.name
  end
  
  should "provide multiple words from vegetables collection" do
    assert_equal "String", Imposter::Vegetable.multiple(4).class.name
  end

  should "provide multiple words from verbs collection" do
    assert_equal "String", Imposter::Verb.multiple(4).class.name
  end
  
  should "create simulated email addresses" do
    assert_match(%r{\S+@\S+\.\S+}, Imposter.email_address())
  end
  
end

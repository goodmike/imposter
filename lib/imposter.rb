require 'faker'
require 'pathname'
require 'active_support'
require 'erubis'

require 'imposter/noun'
require 'imposter/verb'
require 'imposter/animal'
require 'imposter/vegetable'
require 'imposter/mineral'
require 'imposter/csz'
require 'imposter/phone'


require "csv"
if CSV.const_defined? :Reader
  # Ruby 1.8 compatible
  require 'fastercsv'
  Object.send(:remove_const, :CSV)
  CSV = FasterCSV
else
  # CSV is now FasterCSV in ruby 1.9
end

module Imposter
	def self.gencsv(filename,cnt,fields,values)
		vl = values	
		m = Array.new(cnt,0)
		CSV.open(filename,"w") do |csv|
			csv << fields
			begin
			(1..cnt).each do |i|
				row = vl.collect do |v|
				  begin 
            Erubis::Eruby.new(v).evaluate(:i => i.to_s)
				  rescue
					  puts "Imposter.gencsv: Error evaluating #{v.to_s} in #{filename}"
					  puts $!.inspect
				  end
				end
				m[i,0] = row
				csv << row
			end
			rescue
				puts "Some format/data error in  " + filename
			end
		end
		return m
	end

	def self.getfixtures
		fixtures_dir = Dir.glob("test/fixtures/*.csv")
		#Loading existing CSV structures
		if not fixtures_dir.empty? then
			fixtures_dir.each do |fixture_csv|
				fn = Pathname.new(fixture_csv).basename.to_s.chomp(File.extname(fixture_csv))
				eval("@" + fn + "= CSV.open(fixture_csv,'r').to_a  rescue nil") 
			end	
		end
	end

	def self.parseyaml(yamlfilename)
		imp_yaml = YAML.load(File.read(yamlfilename))
		mn = imp_yaml.first[0]
		imp_values = imp_yaml[mn]["fields"].values
		imp_fields = imp_yaml[mn]["fields"].keys
		imp_qty = imp_yaml[mn]["quantity"]
		rl = gencsv("test/fixtures/" + mn.pluralize + ".csv",imp_qty,imp_fields, imp_values) 
    # eval("@" + mn.pluralize + "= rl") -- What does this do?
		yml_fixture_filename = "test/fixtures/#{mn.pluralize}.yml"
		if File.exists?(yml_fixture_filename)
		  puts " ** Deleting YAML fixture file #{yml_fixture_filename}"
		  File.delete(yml_fixture_filename)
	  end 
	end

	def self.genimposters
		models_dir = Dir.glob(Rails.root.join('test', 'imposter').to_s + "/*.yml")
		models_dir.each do |imposter_yaml|
			getfixtures #reloading each time to get model level data		
			parseyaml(imposter_yaml)
		end	
	end

  def announce(message)
    text = "#{@version} #{name}: #{message}"
    length = [0, 75 - text.length].max
    write "== %s %s" % [text, "=" * length]
  end

  def self.urlify
    ('http://www.' + Faker::Internet.domain_name).to_s.downcase
  end
  
  def self.email_address(counter=false)
    if counter
      Faker::Internet.email("#{Imposter::Mineral.one} #{counter}")
    else
      Faker::Internet.email()
    end
  end

	def self.numerify(number_string)
		number_string.gsub(/#/) { rand(10).to_s }
	end

	def self.letterify(letter_string)
		letter_string.gsub(/\?/) { ('a'..'z').to_a.rand }
	end

	def self.pattern(string)
		self.letterify(self.numerify(string))
	end
end

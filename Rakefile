# -*- ruby -*-

require 'rubygems'
require 'hoe'

$: << "lib/"
require 'openx'

HOE = Hoe.new('openx', OpenX::VERSION) do |p|
  # p.rubyforge_name = 'ruby-openxx' # if different than lowercase project name
  p.developer('Aaron Patterson', 'aaron.patterson@gmail.com')
end

task :clean do
  include OpenX::Services
  ENV['OPENX_ENV'] = 'test'
  Agency.find(:all) do |agency|
    Advertiser.find(:all, agency.id).each do |advertiser|
      Campaign.find(:all, advertiser.id).each do |campaign|
        Banner.find(:all, campaign.id).each do |banner|
          banner.destroy
        end
        campaign.destroy
      end
      advertiser.destroy
    end
  end
end

namespace :gem do
  task :spec do
    File.open("#{HOE.name}.gemspec", 'w') do |f|
      f.write(HOE.spec.to_ruby)
    end
  end
end

# vim: syntax=Ruby

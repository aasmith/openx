# -*- ruby -*-

require 'rubygems'
require 'hoe'

$: << "lib/"
require 'openx'

Hoe.new('ruby-openx', OpenX::VERSION) do |p|
  # p.rubyforge_name = 'ruby-openxx' # if different than lowercase project name
  p.developer('FIX', 'FIX@example.com')
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

# vim: syntax=Ruby

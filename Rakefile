# -*- ruby -*-

require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "touchlocal-openx"
    gemspec.summary = "A Ruby interface to the OpenX XML-RPC API"
    gemspec.description = "A Ruby interface to the OpenX XML-RPC API"
    gemspec.email = "info@touchlocal.com"
    gemspec.homepage = "http://github.com/touchlocal/openx"
    gemspec.authors = ["Aaron Patterson", "Andy Smith", "TouchLocal Plc"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

$: << "lib/"
require 'openx'

namespace :openx do
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
end

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))

require 'test/unit'
require 'openx'

#TEST_URL = 'http://okapi.local:8008/www/api/v1/xmlrpc'
#TEST_USERNAME = 'asmith'
#TEST_PASSWORD = 'adready'
TEST_URL = 'http://localhost/~aaron/openx-2.5.70-beta/www/api/v1/xmlrpc'
TEST_USERNAME = 'admin'
TEST_PASSWORD = 'vendo'

module OpenX
  class TestCase < Test::Unit::TestCase
    include OpenX::Services

    undef :default_test

    def agency
      Agency.create!(
        {
          :name         => "Testing! - #{Time.now}",
          :contact_name => 'Contact Name!',
          :email        => 'foo@bar.com'
        }
      )
    end

    def advertiser
      Advertiser.create!(
        {
          :name         => "adv-#{Time.now}",
          :contact_name => 'Contact Name!',
          :email        => 'foo@bar.com'
        }.merge(:agency => @agency)
      )
    end

    def campaign
      Campaign.create!(
        {
          :advertiser => @advertiser,
          :name         => "Campaign-#{Time.now}",
          :impressions => 2000
        }
      )
    end

    def publisher
      Publisher.create!(
        {
          :agency       => @agency,
          :name         => "Publisher! - #{Time.now}",
          :contact_name => 'Aaron Patterson',
          :email        => 'aaron@tenderlovemaking.com',
          :username     => 'one',
          :password     => 'two',
        }
      )
    end
  end
end

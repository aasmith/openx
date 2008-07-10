$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), '../lib')))

require 'test/unit'
require 'openx'

ENV['OPENX_ENV'] = 'test'

module OpenX
  class TestCase < Test::Unit::TestCase
    include OpenX::Services

    undef :default_test

    def setup
      assert(
             File.exists?(Base::CONFIGURATION_YAML),
              'Please create the credentials file'
            )
    end

    def agency
      @agency ||= Agency.create!(
        {
          :name         => "Testing! - #{Time.now}",
          :contact_name => 'Contact Name!',
          :email        => 'foo@bar.com'
        }
      )
    end

    def advertiser
      @advertiser ||= Advertiser.create!(
        {
          :name         => "adv-#{Time.now}",
          :contact_name => 'Contact Name!',
          :email        => 'foo@bar.com'
        }.merge(:agency => agency)
      )
    end

    def campaign
      @campaign ||= Campaign.create!(
        {
          :advertiser => advertiser,
          :name         => "Campaign-#{Time.now}",
          :impressions => 2000
        }
      )
    end

    def publisher
      @publisher ||= Publisher.create!(
        {
          :agency       => agency,
          :name         => "Publisher! - #{Time.now}",
          :contact_name => 'Aaron Patterson',
          :email        => 'aaron@tenderlovemaking.com',
          :username     => 'one',
          :password     => 'two',
        }
      )
    end

    def destroy
      @publisher.destroy if defined? @publisher
      @campaign.destroy if defined? @campaign
      @advertiser.destroy if defined? @advertiser
      @agency.destroy if defined? @agency
    end
  end
end

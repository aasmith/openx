require 'helper'
require 'date'

class CampaignTest < Test::Unit::TestCase
  include OpenX::Services

  def setup
    @session = Session.new(TEST_URL)
    assert_nothing_raised {
      @session.create(TEST_USERNAME, TEST_PASSWORD)
    }
    @agency     = agency
    @advertiser = advertiser
  end

  def destroy
    assert_nothing_raised {
      @advertiser.destroy
      @agency.destroy
      @session.destroy
    }
  end

  def test_create_campaign
    campaign = nil
    assert_nothing_raised {
      campaign = Campaign.create!(init_params)
    }
    assert_not_nil campaign
    init_params.each do |k,v|
      assert_equal(v, campaign.send(:"#{k}"))
    end
  end

  def init_params
    {
      :advertiser => @advertiser,
      :session    => @session,
      :name       => 'Test Campaign',
      :impressions => 2000
    }
  end

  def agency
    Agency.create!(
      {
        :name         => "agency-#{Time.now}",
        :contact_name => 'Contact Name!',
        :email        => 'foo@bar.com'
      }.merge({:session => @session})
    )
  end

  def advertiser
    Advertiser.create!(
      {
        :name         => "adv-#{Time.now}",
        :contact_name => 'Contact Name!',
        :email        => 'foo@bar.com'
      }.merge({:session => @session, :agency => @agency})
    )
  end
end

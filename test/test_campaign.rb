require 'helper'
require 'date'

class CampaignTest < OpenX::TestCase
  def setup
    super
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

  def test_destroy
    a = nil
    assert_nothing_raised {
      a = Campaign.create!(init_params)
    }
    id = a.id
    assert_nothing_raised {
      a.destroy
    }
    assert_raises(XMLRPC::FaultException) {
      Campaign.find(id)
    }
  end

  def test_create_campaign
    campaign = nil
    params = init_params
    assert_nothing_raised {
      campaign = Campaign.create!(params)
    }
    assert_not_nil campaign
    params.each do |k,v|
      assert_equal(v, campaign.send(:"#{k}"))
    end
  end

  def test_find
    a = nil
    params = init_params
    assert_nothing_raised {
      a = Campaign.create!(params)
    }
    assert_not_nil a
    a = Campaign.find(a.id)
    assert a
    assert_equal(params[:advertiser].id, a.advertiser.id)
    params.each { |k,v|
      assert_equal(v, a.send(:"#{k}"))
    }
  end

  def test_find_all
    a = nil
    params = init_params
    assert_nothing_raised {
      a = Campaign.create!(params)
    }
    list = Campaign.find(:all, a.advertiser.id)
    assert list.all? { |x| x.is_a?(Campaign) }
    assert list.any? { |x| x.name == params[:name] }
  end

  def init_params
    {
      :advertiser => @advertiser,
      :name       => "Test Campaign-#{Time.now}",
      :impressions => 2000
    }
  end
end

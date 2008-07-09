require 'helper'
require 'date'

class BannerTest < Test::Unit::TestCase
  TEST_SWF = File.expand_path(File.join(File.dirname(__FILE__), 'assets', 'cat.swf'))
  TEST_JPG = File.expand_path(File.join(File.dirname(__FILE__), 'assets', '300x250.jpg'))

  include OpenX::Services

  def setup
    @session = Session.new(TEST_URL)
    assert_nothing_raised {
      @session.create(TEST_USERNAME, TEST_PASSWORD)
    }
    Base.connection = @session
    @agency     = agency
    @advertiser = advertiser
    @campaign   = campaign
  end

  def destroy
    assert_nothing_raised {
      @campaign.destroy
      @advertiser.destroy
      @agency.destroy
      @session.destroy
    }
  end

  def test_create
    banner = nil
    params = init_params
    assert_nothing_raised {
      banner = Banner.create!(params)
    }
    assert_not_nil banner
    params.each do |k,v|
      assert_equal(v, banner.send(:"#{k}"))
    end
  end

  def test_create_with_jpg
    banner = nil
    params = init_params.merge({
      :image => OpenX::Image.new(File.open(TEST_JPG, 'rb'))
    })
    assert_nothing_raised {
      banner = Banner.create!(params)
    }
    assert_not_nil banner
    params.each do |k,v|
      assert_equal(v, banner.send(:"#{k}"))
    end
  end

  def init_params
    {
      :name         => "Banner-#{Time.now}",
      :storage_type => Banner::LOCAL_SQL,
      :campaign     => @campaign,
      :url          => 'http://tenderlovemaking.com/',
      :file_name    => 'oogabooga',
      :image        => OpenX::Image.new(File.open(TEST_SWF, 'rb'))
    }
  end

  def agency
    Agency.create!(
      {
        :name         => "agency-#{Time.now}",
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
end

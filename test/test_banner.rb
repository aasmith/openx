require 'helper'
require 'date'

class BannerTest < OpenX::TestCase
  TEST_SWF = File.expand_path(File.join(File.dirname(__FILE__), 'assets', 'cat.swf'))
  TEST_JPG = File.expand_path(File.join(File.dirname(__FILE__), 'assets', '300x250.jpg'))

  def test_destroy
    params = init_params
    banner = Banner.create!(params)
    id = banner.id
    assert_nothing_raised {
      banner.destroy
    }
    assert_raises(XMLRPC::FaultException) {
      Banner.find(id)
    }
  end

  def test_find
    params = init_params
    banner = Banner.create!(params)
    assert_not_nil banner
    found_banner = Banner.find(banner.id)
    assert_not_nil found_banner
    assert_equal(banner, found_banner)
  end

  def test_update
    params = init_params
    banner = Banner.create!(params)
    assert_not_nil banner
    banner.name = 'super awesome'
    banner.save!

    found = Banner.find(banner.id)
    assert_equal('super awesome', found.name)
    found.destroy
  end

  def test_find_all
    params = init_params
    banner = Banner.create!(params)
    list = Banner.find(:all, banner.campaign.id)
    assert list.all? { |x| x.is_a?(Banner) }
    assert list.any? { |x| x == banner }
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
      :campaign     => campaign,
      :url          => 'http://tenderlovemaking.com/',
      :file_name    => 'oogabooga',
      :image        => OpenX::Image.new(File.open(TEST_SWF, 'rb'))
    }
  end
end

require 'helper'

class AdvertiserTest < OpenX::TestCase
  def setup
    super
    @agency = agency
  end

  def destroy
    assert_nothing_raised {
      @agency.destroy
      @session.destroy
    }
  end

  def test_create_advertiser
    advertiser = nil
    assert_nothing_raised {
      advertiser = Advertiser.create!(init_params.merge({
        :agency   => @agency,
      }))
    }
    assert_not_nil advertiser
    init_params.each do |k,v|
      assert_equal(v, advertiser.send(:"#{k}"))
    end
  end

  def test_destroy
    a = nil
    assert_nothing_raised {
      a = Advertiser.create!(init_params.merge({:agency => @agency}))
    }
    id = a.id
    assert_nothing_raised {
      a.destroy
    }
    assert_raises(XMLRPC::FaultException) {
      Advertiser.find(id)
    }
  end

  def test_create_advertiser_with_agency
    advertiser = nil
    assert_nothing_raised {
      advertiser = @agency.create_advertiser!(init_params)
    }
    assert_not_nil advertiser
    init_params.each do |k,v|
      assert_equal(v, advertiser.send(:"#{k}"))
    end
  end

  def test_find_advertiser
    advertiser = nil
    assert_nothing_raised {
      advertiser = @agency.create_advertiser!(init_params)
    }
    assert_not_nil advertiser

    original = advertiser
    advertiser = Advertiser.find(advertiser.id)
    assert_equal(original, advertiser)
    assert_not_nil advertiser
    assert_not_nil advertiser.agency
    init_params.each do |k,v|
      assert_equal(v, advertiser.send(:"#{k}"))
    end
  end

  def test_find_all_advertisers
    advertiser = nil
    assert_nothing_raised {
      advertiser = @agency.create_advertiser!(init_params)
    }
    assert_not_nil advertiser

    advertisers = Advertiser.find(:all, @agency.id)

    advertiser = advertisers.find { |a| a.id == advertiser.id }
    assert_not_nil advertiser
    init_params.each do |k,v|
      assert_equal(v, advertiser.send(:"#{k}"))
    end
  end

  def init_params
    {
      :name         => 'Test advertiser',
      :contact_name => 'Contact name',
      :email        => 'email@example.com',
    }
  end
end

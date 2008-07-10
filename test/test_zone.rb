require 'helper'

class ZoneTest < OpenX::TestCase
  def setup
    super
    @agency = agency
    @publisher = publisher
  end

  def destroy
    assert_nothing_raised {
      @agency.destroy
      @session.destroy
    }
  end

  def test_create
    params = init_params
    zone = Zone.create!(params)
    assert_not_nil zone
    params.each do |k,v|
      assert_equal(v, zone.send(:"#{k}"))
    end
    zone.destroy
  end

  def test_find
    params = init_params
    zone = Zone.create!(params)
    assert_not_nil zone
    found_zone = Zone.find(zone.id)
    assert_not_nil found_zone
    assert_equal(zone, found_zone)
    zone.destroy
  end

  def test_find_all
    params = init_params
    zone = Zone.create!(params)
    assert_not_nil zone

    zones = Zone.find(:all, @publisher.id)
    found_zone = zones.find { |z| z.id == zone.id }
    assert found_zone
    assert_equal(zone, found_zone)
    zone.destroy
  end

  def test_destroy
    params = init_params
    zone = Zone.create!(params)
    assert_not_nil zone
    id = zone.id
    assert_nothing_raised {
      zone.destroy
    }
    assert_raises(XMLRPC::FaultException) {
      Zone.find(id)
    }
  end

  def test_update
    params = init_params
    zone = Zone.create!(params)
    assert_not_nil zone

    found_zone = Zone.find(zone.id)
    found_zone.name = 'tenderlove'
    found_zone.save!

    found_zone = Zone.find(zone.id)
    assert_equal('tenderlove', found_zone.name)
  end

  def init_params
    {
      :publisher  => @publisher,
      :name       => "Zone - #{Time.now}",
      :type       => Zone::BANNER,
      :width      => 468,
      :height     => 60,
    }
  end
end

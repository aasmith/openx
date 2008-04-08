require 'helper'

class AgencyTest < Test::Unit::TestCase
  include OpenX::Services

  def setup
    @session = Session.new(TEST_URL)
    assert_nothing_raised {
      @session.create('admin', 'vendo')
    }
  end

  def destroy
    Agency.find(@session, :all).each do |agency|
      agency.destroy if agency.name == init_params[:name]
    end
    assert_nothing_raised {
      @session.destroy
    }
  end

  def test_create!
    a = nil
    assert_nothing_raised {
      a = Agency.create!(init_params.merge({:session => @session}))
    }
    assert_not_nil a
    assert_not_nil a.id
    init_params.each { |k,v|
      assert_equal(v, a.send(:"#{k}"))
    }
  end

  def test_modify
    a = nil
    assert_nothing_raised {
      a = Agency.create!(init_params.merge({:session => @session}))
    }
    assert_not_nil a
    assert_not_nil a.id
    a.name = 'Awesome name!'
    a.save!

    a = Agency.find(@session, a.id)
    assert_equal('Awesome name!', a.name)
    a.destroy
  end

  def test_find
    a = nil
    assert_nothing_raised {
      a = Agency.create!(init_params.merge({:session => @session}))
    }
    a = Agency.find(@session, a.id)
    init_params.each { |k,v|
      assert_equal(v, a.send(:"#{k}"))
    }
  end

  def test_find_all
    a = nil
    assert_nothing_raised {
      a = Agency.create!(init_params.merge({:session => @session}))
    }
    list = Agency.find(@session, :all)
    assert list.all? { |x| x.is_a?(Agency) }
    assert list.any? { |x| x.name == init_params[:name] }
  end

  def test_destroy
    a = nil
    assert_nothing_raised {
      a = Agency.create!(init_params.merge({:session => @session}))
    }
    id = a.id
    assert_nothing_raised {
      a.destroy
    }
    assert_raises(XMLRPC::FaultException) {
      Agency.find(@session, id)
    }
  end

  def test_static_destroy
    a = nil
    assert_nothing_raised {
      a = Agency.create!(init_params.merge({:session => @session}))
    }
    id = a.id
    assert_nothing_raised {
      Agency.destroy(@session, id)
    }
    assert_raises(XMLRPC::FaultException) {
      Agency.find(@session, id)
    }
  end

  def init_params
    {
      :name         => 'Testing!',
      :contact_name => 'Contact Name!',
      :email        => 'foo@bar.com'
    }
  end
end

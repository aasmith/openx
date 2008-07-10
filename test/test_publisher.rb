require 'helper'

class PublisherTest < OpenX::TestCase
  def test_update
    params = init_params
    publisher = Publisher.create!(params)
    found_pub = Publisher.find(publisher.id)
    assert_equal(publisher, found_pub)
    found_pub.name = 'awesome!!!!'
    found_pub.save!

    found_pub = Publisher.find(publisher.id)
    assert_equal('awesome!!!!', found_pub.name)
    found_pub.destroy
  end

  def test_create
    params = init_params
    publisher = Publisher.create!(params)
    assert_not_nil publisher
    params.each do |k,v|
      assert_equal(v, publisher.send(:"#{k}"))
    end
    publisher.destroy
  end

  def test_find
    params = init_params
    publisher = Publisher.create!(params)
    assert_not_nil publisher
    found_pub = Publisher.find(publisher.id)
    assert_equal(publisher, found_pub)
    publisher.destroy
  end

  def test_find_all
    params = init_params
    publisher = Publisher.create!(params)
    publishers = Publisher.find(:all, agency.id)
    pub = publishers.find { |a| a.id == publisher.id }
    assert_not_nil pub
    assert_equal(publisher, pub)
    publisher.destroy
  end

  def test_destroy
    params = init_params
    publisher = Publisher.create!(params)
    assert_not_nil publisher
    id = publisher.id
    assert_nothing_raised {
      publisher.destroy
    }
    assert_raises(XMLRPC::FaultException) {
      Publisher.find(id)
    }
  end

  def init_params
    {
      :agency       => agency,
      :name         => "Publisher! - #{Time.now}",
      :contact_name => 'Aaron Patterson',
      :email        => 'aaron@tenderlovemaking.com',
      :username     => 'one',
      :password     => 'two',
    }
  end
end

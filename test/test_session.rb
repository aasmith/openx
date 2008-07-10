require 'helper'

class SessionTest < OpenX::TestCase
  def test_login
    config = Base.configuration
    session = Session.new(config['url'])
    assert_nothing_raised {
      session.create(config['username'], config['password'])
    }
  end

  def test_logout
    config = Base.configuration
    session = Session.new(config['url'])
    assert_nothing_raised {
      session.create(config['username'], config['password'])
    }
    assert_not_nil session.id
    assert_nothing_raised {
      session.destroy
    }
    assert_nil session.id
  end
end

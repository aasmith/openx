require 'helper'

class SessionTest < Test::Unit::TestCase
  include OpenX::Services

  def test_login
    session = Session.new(TEST_URL)
    assert_nothing_raised {
      session.create('admin', 'vendo')
    }
  end

  def test_logout
    session = Session.new(TEST_URL)
    assert_nothing_raised {
      session.create('admin', 'vendo')
    }
    assert_not_nil session.id
    assert_nothing_raised {
      session.destroy
    }
    assert_nil session.id
  end
end

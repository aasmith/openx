require 'helper'

class SessionTest < OpenX::TestCase
  def test_login
    session = Session.new(TEST_URL)
    assert_nothing_raised {
      session.create(TEST_USERNAME, TEST_PASSWORD)
    }
  end

  def test_logout
    session = Session.new(TEST_URL)
    assert_nothing_raised {
      session.create(TEST_USERNAME, TEST_PASSWORD)
    }
    assert_not_nil session.id
    assert_nothing_raised {
      session.destroy
    }
    assert_nil session.id
  end
end

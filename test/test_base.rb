require 'helper'
require 'fileutils'

class BaseTest < OpenX::TestCase
  def test_configuration_reads_from_yaml
    before_env = ENV['OPENX_ENV']
    exists = false
    contents = nil
    if File.exists?(Base::CONFIGURATION_YAML)
      exists = true
      contents = File.read(Base::CONFIGURATION_YAML)
    end

    config =  {
      'awesome' => {
        'username' => 'aaron',
        'password' => 'p',
        'url' => 'http://tenderlovemaking.com/',
      }
    }
    ENV['OPENX_ENV'] = 'awesome'

    Base.configuration = nil
    FileUtils.mkdir_p(File.dirname(Base::CONFIGURATION_YAML))
    File.open(Base::CONFIGURATION_YAML, 'wb') { |f|
      f.write(YAML.dump(config))
    }
    assert_equal(config['awesome'], Base.configuration)

    FileUtils.rm(Base::CONFIGURATION_YAML) if !exists
    File.open(Base::CONFIGURATION_YAML, 'wb') { |f|
      f.write(contents)
    } if exists
    ENV['OPENX_ENV'] = before_env
    Base.configuration = nil
  end
end

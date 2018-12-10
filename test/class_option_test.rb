require_relative './test_helper'
require 'minitest/autorun'
require 'yaml'
require_relative '../lib/micro_install'
# rubocop:disable Style/MethodLength
class MicroInstallTest < Minitest::Test
  def setup
    @app = MicroInstall

  end
  def test_that_version_option_works
    assert_output(/#{MicroInstall::VERSION}/, '') {
      @app.run(%w(--version))
      @app.run(%w(-v))
    }
  end
end
# rubocop:enable Style/MethodLength
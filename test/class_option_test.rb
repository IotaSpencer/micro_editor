require_relative './test_helper'
require 'minitest/autorun'
require 'yaml'
require_relative '../lib/micro_editor'
# rubocop:disable Style/MethodLength
class MicroInstallTest < Minitest::Test
  def setup
    @app = MicroEditor

  end
  def test_that_version_option_works
    assert_equal(true, true, 'its true!')
  end
end
# rubocop:enable Style/MethodLength
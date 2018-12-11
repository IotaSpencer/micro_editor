lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'micro_editor/version'
require 'rdoc'

Gem::Specification.new do |spec|
  spec.name        = 'micro_editor'
  spec.version     = MicroEditor::VERSION
  spec.authors     = ['Ken Spencer']
  spec.email       = ['me@iotaspencer.me']
  spec.summary     = <<-SUMMARY
  A quick gem to install a script for installing micro,
  used by https://github.com/IotaSpencer/mkmatter
  SUMMARY
  spec.description = <<-DESC
  micro_install is a gem that installs a removable script
  that lets you install 'micro' a terminal text editor,
  this gem allows https://github.com/IotaSpencer/mkmatter
  to require it as a dependency so it can be installed alongside
  it.
  DESC
  spec.homepage    = 'https://iotaspencer.me/projects/micro_editor'
  spec.license     = 'MIT'
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata = {
        'github_repo'       => 'https://github.com/IotaSpencer/micro_editor',
        'bug_tracker_uri'   => 'https://github.com/IotaSpencer/micro_editor/issues',
        #'documentation_uri' => 'https://rubydoc.info/gems/mkmatter', # no documentation as there's no public api
        'homepage_uri'      => 'https://iotaspencer.me/projects/micro_editor',
        'source_code_uri'   => 'https://github.com/IotaSpencer/micro_editor',
        'wiki_uri'          => 'https://github.com/IotaSpencer/micro_editor/wiki'
    }
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end
  
  spec.files                 = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec|test|features)/})
  end
  spec.required_ruby_version = '~> 2'
  spec.bindir                = 'bin'
  spec.executables << 'micro_editor'
  spec.require_paths = ['lib']
  
  spec.add_runtime_dependency 'gli', '~> 2.18.0'
  spec.add_runtime_dependency 'highline', '~> 1.7'
  spec.add_runtime_dependency 'os', '~> 1.0'
  spec.add_runtime_dependency 'paint', '~> 2.0.1'
  spec.add_runtime_dependency 'unirest', '~> 1.1'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'rake', '~> 10.5'
  spec.add_development_dependency 'minitest-reporters', '~> 1.3.4'

  spec.post_install_message = <<-POSTINSTALL
  Thanks for installing micro_editor installer!!
  POSTINSTALL
end

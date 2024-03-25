lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'micro_install/version'
require 'rdoc'

Gem::Specification.new do |spec|
  spec.name        = 'micro_install'
  spec.version     = MicroInstall::VERSION
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
  spec.homepage    = 'https://iotaspencer.me/projects/micro-install'
  spec.license     = 'MIT'
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata = {
        'github_repo'       => 'https://github.com/IotaSpencer/micro-install',
        'bug_tracker_uri'   => 'https://github.com/IotaSpencer/micro-install/issues',
        #'documentation_uri' => 'https://rubydoc.info/gems/mkmatter', # no documentation as there's no public api
        'homepage_uri'      => 'https://iotaspencer.me/projects/micro-install',
        'source_code_uri'   => 'https://github.com/IotaSpencer/micro-install',
        'wiki_uri'          => 'https://github.com/IotaSpencer/micro-install/wiki'
    }
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end
  
  spec.files                 = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(spec|test|features)/})
  end
  spec.required_ruby_version = '~> 3'
  spec.bindir                = 'bin'
  spec.executables << 'micro-install'
  spec.require_paths = ['lib']
  
  spec.add_runtime_dependency 'thor', '~> 1.3.1'
  spec.add_runtime_dependency 'highline', '~> 3.0.1'
  spec.add_runtime_dependency 'os', '~> 1.1.4'
  spec.add_runtime_dependency 'paint', '~> 2.3.0'
  spec.add_runtime_dependency 'httparty', '~> 0.21.0'
  spec.add_development_dependency 'bundler', '~> 2.3.5'
  spec.add_development_dependency 'pry', '~> 0.14.2'
  spec.add_development_dependency 'rake', '~> 13.1.0'
  spec.add_development_dependency 'minitest-reporters', '~> 1.6.1'

  spec.post_install_message = <<-POSTINSTALL
  Thanks for installing micro_install!
  POSTINSTALL
end

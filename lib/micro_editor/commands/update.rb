require 'gli'
module MicroEditor
  # Cloudflare CLI App class
  class App
    extend GLI::App

    desc 'Download micro'
    command :get do |c|
      c.flag :path, desc: 'path to save micro to', default_value: Pathname(Dir.home).join()
    end
  end
end

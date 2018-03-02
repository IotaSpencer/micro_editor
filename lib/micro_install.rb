require "micro_install/version"
require 'micro_install/spinner'
require 'unirest'
require 'os'
require 'highline'
require 'paint'
module MicroInstall
  class LookupError < Exception
  end
  
  class Installer
    
    def initialize(hl = HighLine.new($stdin, $stdout))
      @hl = hl
    end
    
    def latesttag(hl = @hl)
      hl.say "#{Paint["Getting Latest Tag", 'green']}"
      MicroInstall.show_wait_spinner {
        body = Unirest.get('https://api.github.com/repos/zyedidia/micro/releases/latest').body
        @tag = body['tag_name'].gsub(/^v/, '')
      }
      puts
      hl.say "#{Paint['Latest Tag', 'green']}: #{Paint[@tag, 'yellow']}"
    end
    
    def get_arch(hl = @hl)
      host_os = OS.config['host_os']
      bits    = OS.bits.to_s
      case host_os
        when "linux-gnu"
          if bits == "64"
            @arch = 'linux64'
          elsif bits == "32"
            @arch = 'linux32'
          end
        when "linux-arm"
          raise self.LookupError 'ARM (mobile devices) are not supported'
        when "darwin"
          @arch = 'osx'
        when "freebsd"
          if bits == "64"
            @arch = 'freebsd64'
          elsif bits == "32"
            @arch = 'freebsd32'
          end
        when "openbsd"
          if bits == "64"
            @arch = 'openbsd64'
          elsif bits == "32"
            @arch = 'openbsd32'
          end
        when "netbsd"
          if bits == "64"
            @arch = 'netbsd64'
          elsif bits == "32"
            @arch = 'netbsd32'
          end
        else
          raise self.LookupError 'unable to determine your system'
      end
      
    end
    
    def download_url(hl = @hl)
      @download_url = "https://github.com/zyedidia/micro/releases/download/v#{@tag}/micro-#{@tag}-#{@arch}.tar.gz"
      hl.say("#{Paint['URL', 'yellow']}: #{@download_url}")
    end
    
    def download_micro_tar(hl = @hl)
      "Downloading"
      MicroInstall.show_wait_spinner {
        File.open("micro-#{@tag}-#{@arch}.tar.gz", "wb") do |saved_file|
          # the following "open" is provided by open-uri
          open("#{@download_url}", "rb") do |read_file|
            saved_file.write(read_file.read)
          end
        end
      }
    end
    
    def extract_micro
      micro_tar = Gem::Package::TarReader.new(Zlib::GzipReader.open("micro-#{@tag}-#{@arch}.tar.gz"))
      micro_tar.rewind
      dest = nil
      micro_tar.each do |entry|
        dest ||= Pathname(Dir.home).realdirpath.join(entry.full_name).to_path
        if entry.directory?
          File.delete dest if File.file? dest
          FileUtils.mkdir_p dest, :mode => entry.header.mode, :verbose => false
        elsif entry.file?
          FileUtils.rm_rf dest if File.directory? dest
          File.open dest, "wb" do |f|
            f.print entry.read
          end
          FileUtils.chmod entry.header.mode, dest, :verbose => false
        elsif entry.header.typeflag == '2' #Symlink!
          File.symlink entry.header.linkname, dest
        end
        dest = nil
      end
    end
    
    def install_micro(hl = @hl)
      FileUtils.mkdir_p(Pathname(Dir.home).join('.local/bin/'))
      
      FileUtils.cp(Pathname(Dir.home).join("micro-#{@tag}/micro"), Pathname(Dir.home).join('.local/bin/'))
      FileUtils.remove("micro-#{@tag}-#{platform}.tar.gz")
      FileUtils.rmtree("micro-#{@tag}")
    end
  end
end

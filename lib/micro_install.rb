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
    attr :arch
    def initialize(hl = HighLine.new($stdin, $stdout))
      @hl = hl
    end

    def latesttag(hl = @hl)
      begin
        hl.say "#{Paint["Getting Latest Tag", 'green']}"
        MicroInstall.show_wait_spinner {
          body = Unirest.get('https://api.github.com/repos/zyedidia/micro/releases/latest').body
          @tag = body['tag_name'].gsub(/^v/, '')
        }
        hl.say "#{Paint['Latest Tag', 'green']}: #{Paint[@tag, 'yellow']}"
      rescue
        hl.say "#{Paint['Error', 'red']}: Unable to retrieve latest release."
      end
    end

    def get_arch(hl = @hl)
      begin
        host_os = OS.config['host_os']
        bits    = OS.bits.to_s
        case host_os
        when "linux-gnu"
          if bits == "64"
            @arch = 'linux64'
          elsif bits == "32"
            @arch = 'linux32'
          end
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

        end
        if OS.config['host_cpu'] == 'arm' or OS.config['host_os'] =~ /linux-arm/ or OS.config['host_os'] =~ /arm-linux/
          @arch = 'linux-arm'
        end
        if @arch.nil?
          raise MicroInstall::LookupError.new 'Unable to determine your system'
        end
      rescue MicroInstall::LookupError => e
        hl.say "#{Paint['Error', 'red']}: #{e}"
      end

    end

    def download_url(hl = @hl)
      @download_url = "https://github.com/zyedidia/micro/releases/download/v#{@tag}/micro-#{@tag}-#{@arch}.tar.gz"
      hl.say("#{Paint['URL', 'yellow']}: #{@download_url}")
    end

    def download_micro_tar(hl = @hl)
      hl.say "Downloading... "
      MicroInstall.show_wait_spinner {
        File.open("micro-#{@tag}-#{@arch}.tar.gz", "wb") do |saved_file|
          # the following "open" is provided by open-uri
          open("#{@download_url}", "rb") do |read_file|
            saved_file.write(read_file.read)
          end
        end
      }
      print "\n"
    end

    def extract_micro(hl = @hl)
      begin
        hl.say Paint["Extracting micro-#{@tag}-#{@arch}.tar.gz", 'yellow']
        micro_tar = Gem::Package::TarReader.new(Zlib::GzipReader.open("micro-#{@tag}-#{@arch}.tar.gz"))
        micro_tar.rewind
        dest = nil
        micro_tar.each do |entry|
          dest ||= Pathname(Dir.home).realdirpath.join(entry.full_name).to_path
          if entry.directory?
            File.delete dest if File.file? dest
            FileUtils::Verbose.mkdir_p dest, :mode => entry.header.mode
          elsif entry.file?
            FileUtils::Verbose.rm_rf dest if File.directory? dest
            File.open dest, "wb" do |f|
              f.print entry.read
            end
            FileUtils::Verbose.chmod entry.header.mode, dest
          elsif entry.header.typeflag == '2' #Symlink!
            File.symlink entry.header.linkname, dest
          end
          dest = nil
        end
      rescue
        hl.say "#{Paint['Error']}: Could not extract micro due to an error."

      end

    end

    def install_micro(hl = @hl)
      hl.say "#{Paint['Checking if ~/.local/bin exists.', 'yellow']}"
      if Dir.exist? Pathname(Dir.home).join('.local/bin')
        hl.say "'~/.local/bin' exists."
      else
        hl.say "'~/.local/bin' doesn't exist, creating."
        begin
          FileUtils.mkdir_p(Pathname(Dir.home).join('.local/bin'))
          hl.say "created '~/.local/bin'"
        rescue Errno::ENOENT => e
          hl.say "#{Paint['Error', 'red']}: #{e}"
        end
      end
      begin
        FileUtils.cp(Pathname(Dir.home).join("micro-#{@tag}/micro"), Pathname(Dir.home).join('.local/bin/'))
        hl.say Paint["Installed 'micro' to ~/.local/bin/"]
      rescue Errno::ENOENT => e
        hl.say "#{Paint['Error', 'red']}: #{e}"
      end
      begin
        FileUtils.rm("micro-#{@tag}-#{@arch}.tar.gz")
      rescue Errno::ENOENT => e
        hl.say "#{Paint['Error', 'red']}: #{e}"
      end
      begin
        FileUtils.rm_r(Pathname(Dir.home).join("micro-#{@tag}"), :secure => true)
      rescue Errno::ENOENT => e
        hl.say "#{Paint['Error', 'red']}: #{e}"
      end
    end

    def is_installed(hl = @hl)
      hl.say [
                 "Micro has been installed to your ~/.local/bin/ directory. You can run it with:",
                 "'micro'"
             ].join
    end

    def is_installed_but_no_bin(hl = @hl)
      hl.say [
                 "Micro is installed to ~/.local/bin/, but can't run,",
                 "Please check your ~/.bashrc and/or ~/.profile and see",
                 "if '~/.local/bin/' is being added to the PATH variable"
             ]
    end
  end
end

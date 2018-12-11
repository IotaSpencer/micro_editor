require 'gli'
require 'json'

module MicroEditor
  # Have a class for the GLI space
  class App
    extend GLI::App
    program_desc 'Install \'micro\'!'
    program_long_desc <<~HEREDOC
    #{exe_name} is used to install 'micro' a command line
    text editor.
    HEREDOC

    version MicroEditor::VERSION
    subcommand_option_handling :normal
    arguments :strict
    wrap_help_text :verbatim
    commands_from 'micro_editor/commands'
  end
end

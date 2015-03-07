begin
  require 'terminal-notifier'
rescue LoadError
  # NOOP - "TerminalNotifier" is optional
  # will only be used if it is installed!
end

module Git
  module Meta

    module_function

    def notify(message, options = {}, verbose = false)
      # send a given message to the Mac OS X Notification Center
      # but only if the git-meta script is running interactively
      # and if the "terminal-notifier" gem has been installed...
      if interactive? && defined?(TerminalNotifier)
        options[:title] ||= 'git-meta'
        TerminalNotifier.notify(message, options, verbose)
      end
    end

  end
end
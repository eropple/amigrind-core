require "logger"

module Amigrind
  module Core
    # Miscellaneous logging stuff.
    module Logging
      # @return [Logger] the application logger
      def self.logger
        @logger
      end

      @logger = Logger.new($stderr)
      @logger.level = (ENV['AMIGRIND_DEBUG'] == '1') ? Logger::DEBUG : Logger::INFO

      # Sets the log level of the logger assigned to Amigrind. Must be one of:
      #
      # - `:debug`
      # - `:info`
      # - `:warn`
      # - `:error`
      #
      # @param name [Symbol] log level by name - one of `:debug`, `:info`, `:warn`, or `:error`
      def self.log_level(name)
        @logger.level =
          case name
          when :debug
            Logger::DEBUG
          when :info
            Logger::INFO
          when :warn
            Logger::WARN
          when :error
            Logger::ERROR
          else
            raise "Invalid log level: #{name}"
          end
      end

      # Helper methods to be mixed into classes that must perform logging. (So, most of them.)
      module Mixin
        # Returns the logger used by {Amigrind::Core::Logging}.
        def logger
          Amigrind::Core::Logging.logger
        end

        # Records a log with debug priority.
        # @param msg [String] the message to record to the logger
        def debug_log(msg)
          Amigrind::Core::Logging.logger.debug msg
        end

        # Records a log with info priority.
        # @param msg [String] the message to record to theimpo logger
        def info_log(msg)
          Amigrind::Core::Logging.logger.info msg
        end

        # Records a log with warn priority.
        # @param msg [String] the message to record to the logger
        def warn_log(msg)
          Amigrind::Core::Logging.logger.warn msg
        end

        # Records a log with error priority.
        # @param msg [String] the message to record to the logger
        def error_log(msg)
          Amigrind::Core::Logging.logger.error msg
        end
      end
    end
  end
end
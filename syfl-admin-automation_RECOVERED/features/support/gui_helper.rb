## frozen_string_literal: true

require "colorize"

# sets the format for the logging timestamp
TIMESTAMP_FORMAT = "[%H:%M:%S.%L]".freeze

# The frameworks title
FRAMEWORK = "[Autobot]".freeze

# A list of colours for the rainbow effect
COLOURS = ["cyan", "yellow", "green", "magenta", "light_red", "light_green", "light_cyan", "light_magenta blue"].freeze

# Logs a message to stdout, includes a time stamp. Use this instead of Kernel.puts
#
# @param message [String] The message to log to console
# @param level [Symbol] Optional, but not really! The log level to use, can be the following:
# * :info - use for information
# * :notice - use when you need to notice some information
# * :low - use for unimportant info
# * :low_notice - use for when you need to notice some information
# * :statement - use for a statement of action completed, or result of
# * :warn - use for a warning
# * :muted - use for text that really doesn't matter in most cases
# * :error - use in case of an error
# * no level
def log(message, level = nil)
  time_stamp = "#{Time.now.strftime(TIMESTAMP_FORMAT)} ".white
  $colour ||= 0
  framework = ""
  FRAMEWORK.split("").each do |letter|
    framework << letter.public_send(COLOURS[$colour % (COLOURS.length - 1)])
    $colour += 1
  end

  case level
  when :info
    Kernel.puts framework + time_stamp + message.to_s.cyan
  when :notice
    Kernel.puts framework + time_stamp + message.to_s.green
  when :low_notice
    Kernel.puts framework + time_stamp + message.to_s.light_green
  when :low
    Kernel.puts framework + time_stamp + message.to_s.light_blue
  when :statement
    Kernel.puts framework + time_stamp + message.to_s.magenta
  when :muted
    Kernel.puts framework + time_stamp + message.to_s.light_black
  when :warn
    Kernel.puts framework + time_stamp + message.to_s.light_red
  when :error
    Kernel.puts framework + time_stamp + message.to_s.red
  when :to_report
    p message
  else
    Kernel.puts framework + time_stamp + message.to_s
  end
end

#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-

require_relative "bot"
require_relative "module_handler"

config_file =  (ARGV.shift || "config.yml")

module_handler = ModuleHandler.new
bot = Bot.new(config_file, module_handler)
bot.connect()
begin
  while true
    bot.handle_state
  end
rescue Interrupt
rescue Exception => detail
  puts detail.message()
  print detail.backtrace.join("\n")
  retry
end

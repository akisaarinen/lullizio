#!/usr/bin/env ruby -wKU

require "bot"
require "module_handler"

base_path = ARGV.shift
config_file = base_path + "/" + (ARGV.shift || "config.yml")

module_handler = ModuleHandler.new
bot = Bot.new(base_path, config_file, module_handler)
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

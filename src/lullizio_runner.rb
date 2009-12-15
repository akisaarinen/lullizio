require 'lullizio'

base_path = ARGV.shift
config_file = base_path + "/" + (ARGV.shift || "config.yml")
bot = Bot.new(base_path, config_file)
bot.modules_reload()

bot.connect()
begin
  bot.main_loop()
rescue Interrupt
rescue Exception => detail
  puts detail.message()
  print detail.backtrace.join("\n")
  retry
end

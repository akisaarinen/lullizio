class ModuleHandler
  attr_accessor :modules

  def reload(bot, modules_dir, excluded_modules)
    @bot = bot
    @modules_dir = modules_dir
    @excluded_modules = excluded_modules
    @modules = []
    Dir.new(@modules_dir).entries.
      select { |m| m =~ /^module_.*\.rb$/ && !m.include?("_spec") }.
      map { |m| 
        m =~ /^module_(.*)\.rb$/
        $1
      }.
      delete_if { |m| @excluded_modules.include?(m) }.each { |m|
        begin
          Kernel.load("#{@modules_dir}/module_#{m}.rb")
          classCreationExpr = "Module_#{m.capitalize}.new"
          #puts "Creating #{m} with '#{classCreationExpr}'"
          instance = eval(classCreationExpr)
          begin
            instance.init_module(@bot)
            modules.push(instance)
            puts "Registered module #{m}"
          rescue Exception => e
            puts "Error initializing module #{m}: #{e}"
            print e.backtrace.join("\n")
          end
        rescue Exception => e
          puts "Error registering module #{m}: #{e.message}"
          print e.backtrace.join("\n")
        end
      }
  end

  def handle_privmsg(from, target, msg)
    if target == @bot.nick 
      reply_to = from
    else
      reply_to = target
    end

    @modules.each { |m|
      begin
        m.privmsg(@bot, from, reply_to, msg)
      rescue Exception => e
        puts "Error calling privmsg for #{m}: #{e.message}"
        print e.backtrace.join("\n")
      end
    }
  end
  
  def handle_botmsg(target, msg)
    @modules.each { |m|
      begin
        m.botmsg(@bot, target, msg)
      rescue Exception => e
        puts "Error calling botmsg for #{m}: #{e.message}"
        print e.backtrace.join("\n")
      end
    }
  end
end

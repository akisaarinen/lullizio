class Bot
  def modules_reload
    @modules = []
    Dir.new(@modules_dir).entries.
      select { |m| m =~ /^module_.*\.rb$/ }.
      map { |m| 
        m =~ /^module_(.*)\.rb$/
        $1
      }.
      delete_if { |m| @excluded_modules.include?(m) }.each { |m|
        begin
          Kernel.load("#{@modules_dir}/module_#{m}.rb")
          @modules.push(m)
          puts "Registered module #{m}"
          begin
            init_method = "#{m}_initialize"
            method(init_method).call(self)
          rescue NoMethodError => nme
          rescue NameError => ne
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

  def modules_privmsg(from, reply_to, msg)
    @modules.each { |m|
      begin
        name = "#{m}_privmsg"
        method(name).call(self, from, reply_to, msg)
      rescue NoMethodError => nme
      rescue Exception => e
        puts "Error calling privmsg for #{m}: #{e.message}"
        print e.backtrace.join("\n")
      end
    }
  end
end

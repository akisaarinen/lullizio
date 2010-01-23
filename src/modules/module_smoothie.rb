require 'htmlentities'

Kernel.load("fetch_uri.rb")

class Module_Smoothie
  def init_module(bot) 
    @ingredient_ids = {
      "kiivi" => 11050,
      "omena" => 11061,
      "paaryna" => 11062,
      "banaani" => 11049,
      "pekoni" => 707,
      "nakki" => 30317,
      "olut" => 902
    }
    @known_products = {
      "eineshampurilainen" => { "kcal" => 70 },
      "tropicana" => {"kcal" => 50 },
      "gefilus" => {"kcal" => 41 }
    }
  end
  
  def privmsg(bot, from, reply_to, msg)
    if msg == "!smoothie"
      bot.send_privmsg(reply_to, "!smoothie <aine:grammat>. Esim: !smoothie omena:150 paaryna:163 kiivi:57, huom. ei tue aeaekkoesiae :)")
    elsif msg =~ /^!smoothie (.*)/
      ingredients = $1
      kcalsTotal = 0
      ignored_format = []
      unknown_products = []
      ingredients.split(" ").each { |ingredient|
        id = nil
        if ingredient =~ /(.*):([0-9]+)/
          name = $1
          amountInGrams = $2.to_f
          if (id = @ingredient_ids[name]) != nil 
            page = fetch_uri("http://www.fineli.fi/food.php?foodid=#{id}&lang=fi")
            kcals = kcalById(id, page)
            if kcals != nil 
              kcalsTotal += kcals * (amountInGrams / 100.0)
            else
              unknown_products.push(name)
            end
          elsif (product = @known_products[name]) != nil
            kcalsTotal += product["kcal"] * (amountInGrams / 100.0)
          else
            unknown_products.push(name)
          end
        else
          ignored_format.push(ingredient)
        end

      }
      bot.send_privmsg(reply_to, "Laskennallinen energiasisältö: #{kcalsTotal} kcal")
      if ignored_format != [] || unknown_products != []
        bot.send_privmsg(reply_to, "Vaarassa formaatissa: [#{ignored_format.join(",")}], Tuntemattomat aineet: [#{unknown_products.join(",")}]")
      end
    end
  end

  private

  def kcalById(id, page) 
    if page.body =~ /energia laskennallinen<\/a><\/td><td align="right">([0-9]+)&nbsp;\(([0-9]+)\)/m
      return $2.to_f 
    else
      return nil
    end
  end

end


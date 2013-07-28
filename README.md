A simple IRC bot written in Ruby, mostly for my own amusement purposes. Has
been running in production since 2009. Not the prettiest little fellow, but
scratches my itch very well. Occasionally updated with new features when needs
pop up.

Features
--------
* Dynamic reloading of modules on-the-fly so the bot can stay online while being
  updated. This makes doing small improvements or hacks convenient.
* A few useful modules to improve the IRC experience
  * YouTube: fetch youtube urls and tell the title, rating etc.
  * Twitter: show contents of a twitter status link
  * Newstitle: fetch and shout title to channel for popular Finnish news sites
    when somene posts an url to a piece of news
* A few less useful modules, just for the lulz:
  * Monkey: define your own monkey-like replies with regexps. E.g. when someone says anything
    containing "banana", the bot may reply "mm, yummy banana!". Let your imagination
    be the limit of what the MonkeyModule (TM) can do.
  * LMGTFY: someone asks a stupid question? No problem, you can be a smartass and
    support this by easily linking the topic in [lmgtfy](http://lmgtfy.com/?q=lmgtfy).

Installing
----------

1. Install Ruby >= 1.9 (tested using Ruby 1.9.3 and `rvm`)
2. `bundle install`
3. `cp example_config.yml my_bot.yml`
4. `vim my_bot.yml`
5. `bin/lullizio my_bot.yml`

Additionally, if you want to use Twitter support, export the following
environment variables before running:

```
export TWITTER_CONSUMER_KEY=""
export TWITTER_CONSUMER_SECRET=""
export TWITTER_OAUTH_TOKEN=""
export TWITTER_OAUTH_TOKEN_SECRET=""
```

The runner will automatically check for `lullizio.env`, and load it before
starting the bot, so that could be the place to add them. Or somewhere else,
whatever.

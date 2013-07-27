A simple IRC bot written in Ruby, mostly for my own amusement purposes.

Features
--------
* Dynamic reloading of modules on-the-fly so the bot can stay online while being
  updated. Ruby makes this rather easy.
* A few useful modules to improve the IRC experience
  * YouTube: fetch youtube urls and tell the title, rating etc. to channel
  * Twitter: show contents of a twitter status link
  * Newstitle: fetch and shout title to channel for popular Finnish news sites
    when somene posts an url to a piece of news
* A few less useful modules, just for the lulz:
  * Monkey: define your own monkey-like replies with regexps. E.g. when someone says anything
    containing "banana", the bot may reply "mm, yummy banana!". Let your imagination
    be the limit of what the MonkeyModule (TM) can do.
  * LMGTFY: someone asks a stupid question? No problem, you can be a smartass and
    support this by easily linking the topic in [lmgtfy](http://lmgtfy.com/?q=lmgtfy).

References
----------
Based originally loosely on example code from http://snippets.dzone.com/posts/show/1785.

Requirements
------------

* Ruby 1.8.7
* `gem install shoulda mocha htmlentities json twitter`

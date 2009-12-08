def load_config 
  return { 
    'server' => 'irc.elisa.fi',
    'port' => 6667,
    'nick' => 'my_bot',
    'username' => 'my_bot',
    'realname' => 'My Bot',
    'channels' => ["#mybot_pwns"],
    'modules_dir' => 'modules',
    'modules' => ['youtube']
  }
end

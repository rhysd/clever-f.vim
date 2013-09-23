# encoding: utf-8

require 'terminal-notifier'

def which cmd
  dir = ENV['PATH'].split(':').find {|p| File.executable? File.join(p, cmd)}
  File.join(dir, cmd) unless dir.nil?
end

def notify m
  msg = "'#{m}\\n#{Time.now.to_s}'"
  case
  when which('terminal-notifier')
    `terminal-notifier -message #{msg}`
  when which('notify-send')
    `notify-send #{msg}`
  when which('tmux')
    `tmux display-message #{msg}` if `tmux list-clients 1>/dev/null 2>&1` && $?.success?
  end
end


guard :shell do
  watch /^(autoload|plugin|t)\/.+\.vim$/ do
    system "rake test"
    unless $?
      notify "test(s) failed"
    end
  end
end

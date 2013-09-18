#!/usr/bin/env ruby
# encoding: utf-8

%w[ cp932 euc-jp utf-8 ].each do |encoding|
  [*'a'..'z', *'A'..'Z'].each do |alpha|
    system "cmigemo -v -w #{alpha} -d /usr/local/share/migemo/#{encoding}/migemo-dict >> #{encoding}.vim && echo >> #{encoding}.vim"
  end
end

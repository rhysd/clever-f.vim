#!/usr/bin/env ruby
# encoding: utf-8

require './t/vspec_helper'

v = Vspec.new(vspec_root: "./vim-vspec")
v.run "t/vspec.vim", autoloads: ['./vim-vspec-matchers']
puts v.result
exit 1 if ! v.success? || v.count_failed > 0

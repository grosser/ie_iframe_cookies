require 'rubygems'
require 'action_pack'
require 'action_controller'
require 'action_controller/test_process'
require 'test/unit'
require 'redgreen' rescue nil

$LOAD_PATH << 'lib'

# fake rails env for initialisation
# when Rails is defined, backtrace_cleaner is used, when assert fails
RAILS_ENV='development'

ActionController::Routing::Routes.reload

require "init"

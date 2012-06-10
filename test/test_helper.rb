require 'action_pack'
require 'action_controller'
require 'test/unit'

if ActionPack::VERSION::MAJOR > 2
  require 'action_dispatch/testing/test_process'
  ActionController::TestCase::Behavior # autoloads

  ROUTES = ActionDispatch::Routing::RouteSet.new
  ROUTES.draw do
    match ':controller(/:action(/:id(.:format)))'
  end
  ROUTES.finalize!

  class ActionController::TestRequest
    def cookie_jar
      cookies
    end
  end
else
  require 'action_controller/test_process'
  ActionController::Routing::Routes.reload rescue nil
end

$LOAD_PATH << 'lib'
require 'ie_iframe_cookies/version'

# fake rails env for initialisation
# when Rails is defined, backtrace_cleaner is used, when assert fails
RAILS_ENV = 'development'

require "./init"

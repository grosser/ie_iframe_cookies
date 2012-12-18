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

  # get routes working without having to mess in actual test
  ActionController::TestCase.setup do
    @routes = ROUTES
  end

  ActionController::TestRequest.class_eval do
    def cookie_jar
      cookies.instance_variable_set(:@set_cookies, {})
      def cookies.recycle!
      end
      cookies
    end
  end
else
  require 'action_controller/test_process'
  ActionController::Routing::Routes.reload rescue nil

  # do not try to load helpers
  ActionController::Helpers::ClassMethods.class_eval do
    def inherited_with_helper(*args)
      inherited_without_helper(*args)
    end
  end
end

$LOAD_PATH << 'lib'
require 'ie_iframe_cookies/version'
require 'ie_iframe_cookies'

# fake rails env for initialisation
# when Rails is defined, backtrace_cleaner is used, when assert fails
RAILS_ENV = 'development'

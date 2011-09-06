require 'test/test_helper'

class IETestController < ActionController::Base
  before_filter :normal_cookies_for_ie_in_iframes!, :only => :activate

  def activate
    render :text => 'OK'
  end
end

class IEIFrameCookiesTest < ActionController::TestCase
  def setup
    @controller = IETestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  test "it has a VERSION" do
    assert_match /^\d+\.\d+\.\d+$/, IEIframeCookies::VERSION
  end

  test "it sets tracking cookie for IE users" do
    @request.env['HTTP_USER_AGENT'] = 'Mr. MSIE is coming...'
    get :activate
    assert_equal 'OK', @response.body
    assert_equal "true", cookies['using_iframes_in_ie']
  end

  test "does not set tracking cookie for nice users" do
    get :activate
    assert_equal 'OK', @response.body
    assert_equal nil, cookies['using_iframes_in_ie']
  end
end

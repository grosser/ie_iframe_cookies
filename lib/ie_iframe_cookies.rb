class IEIframeCookies
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip
end


module ActionController
  class Base
    before_filter :normal_cookies_for_ie_in_iframes

    def normal_cookies_for_ie_in_iframes!
      if request.ie_iframe_cookies_browser_is_ie?
        normal_cookies_for_ie_in_iframes(:force => true)
        cookies["using_iframes_in_ie"] = true
      end
    end

    def normal_cookies_for_ie_in_iframes(options={})
      headers['P3P'] = 'CP="ALL DSP COR CURa ADMa DEVa OUR IND COM NAV"' if request.normal_cookies_for_ie_in_iframes? or options[:force]
    end
  end
end

module ActionDispatch::Http::Cache::Request
  def ie_iframe_cookies_browser_is_ie?
    (env['HTTP_USER_AGENT'] || "").include?("MSIE")
  end

  def normal_cookies_for_ie_in_iframes?
    ie_iframe_cookies_browser_is_ie? and cookies["using_iframes_in_ie"]
  end

  alias_method :etag_matches_without_ie_iframe_cookies?, :etag_matches?
  def etag_matches?(*args)
    not normal_cookies_for_ie_in_iframes? and etag_matches_without_ie_iframe_cookies?(*args)
  end

  alias_method :not_modified_without_ie_iframe_cookies?, :not_modified?
  def not_modified?(*args)
    not normal_cookies_for_ie_in_iframes? and not_modified_without_ie_iframe_cookies?(*args)
  end
end

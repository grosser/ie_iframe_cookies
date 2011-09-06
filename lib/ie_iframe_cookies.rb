class IEIframeCookies
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip
end

module ActionController
  class Base
    before_filter :normal_cookies_for_ie_in_iframes

    def normal_cookies_for_ie_in_iframes!
      enable_normal_cookies_for_ie_in_iframes(:force => true)
      cookies["using_iframes_in_ie"] = true
    end

    def normal_cookies_for_ie_in_iframes(options={})
      headers['P3P'] = 'CP="ALL DSP COR CURa ADMa DEVa OUR IND COM NAV"' if request.wants_normal_cookies_for_ie_in_iframes? or options[:force]
    end
  end

  class Request
    alias_method :etag_matches_without_ie_iframe_cookies?, :etag_matches?

    def normal_cookies_for_ie_in_iframes?
      (env['HTTP_USER_AGENT'] || "").include?("MSIE") and cookies["using_iframes_in_ie"]
    end

    def etag_matches?(etag)
      not normal_cookies_for_ie_in_iframes? and etag_matches_without_ie_iframe_cookies?(etag)
    end
  end

  class Response
    alias_method :etag_without_ie_iframe_cookies?, :etag?

    def etag?
      request.normal_cookies_for_ie_in_iframes? or etag_without_ie_iframe_cookies?
    end
  end
end

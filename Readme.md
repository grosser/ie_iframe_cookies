Rails: Enabled cookies inside IFrames for IE via P3P headers.<br/>

IFrames in IE only get the same cookies as normal pages when P3P headers are added<br/>
=> 'iframe-using' IE users get P3P headers on every request<br/>
304 Not modified pages do not get P3P headers (via ETag)<br/>
=> 'iframe-using' IE users do not get 304

Install
=======
    sudo gem install ie_iframe_cookies
Or

    rails plugin install git://github.com/grosser/ie_iframe_cookies.git


Usage
=====
To cookie-tag users as 'iframe-using', add this to all actions rendered inside IFrames.<br/>
(only IE users are tagged)

    before_filter :normal_cookies_for_ie_in_iframes! # :only => [:foo, :bar]

Authors
=======

### [Contributors](http://github.com/grosser/ie_iframe_cookies/contributors)
 - [Eric Harrison](https://github.com/fuelxc)

[Sascha Depold](https://github.com/sdepold)

[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
Hereby placed under public domain, do what you want, just do not hold me accountable...

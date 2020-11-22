module ActionView
  module RoutingUrlFor
    alias_method :_url_for, :url_for
    def url_for(options = nil)
      host = 'http://localhost:5000'
      if Rails.env.production? && ENV['BASE_HOST'].present?
        host = ENV['BASE_HOST']
      end
      if options.instance_of? String
        options.sub! 'http://localhost:3000', host
      end
      _url_for(options)
    end
  end
end
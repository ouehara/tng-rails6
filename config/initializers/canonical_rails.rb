# Do yourself a favor and set these up right when you install the engine.

CanonicalRails.setup do |config|

  # Force the protocol. If you do not specify, the protocol will be based on the incoming request's protocol.

  config.protocol#= 'https://'

  # This is the main host, not just the TLD, omit slashes and protocol. If you have more than one, pick the one you want to rank in search results.

  config.host = 'www.tsunagujapan.com'
  #config.port = ''

  # http://en.wikipedia.org/wiki/URL_normalization
  # Trailing slash represents semantics of a directory, ie a collection view - implying an :index get route;
  # otherwise we have to assume semantics of an instance of a resource type, a member view - implying a :show get route
  #
  # Acts as a whitelist for routes to have trailing slashes

  config.collection_actions = [:index,:show]

  # Parameter spamming can cause index dilution by creating seemingly different URLs with identical or near-identical content.
  # Unless whitelisted, these parameters will be omitted

  config.whitelisted_parameters = [:page]

  # Output a matching OpenGraph URL meta tag (og:url) with the canonical URL, as recommended by Facebook et al
  config.opengraph_url= false
end
CanonicalRails::TagHelper.module_eval do
  def canonical_href(host = canonical_host, port = canonical_port, force_trailing_slash = nil)
    port = port.present? && port.to_i != 80 ? ":#{port}" : ''
    if controller_name == "article" || controller_name == "articles" || controller_name == "index" || controller_name == "category"
      raw "#{canonical_protocol}#{host}#{path_without_html_extension}#{trailing_slash_config(force_trailing_slash)}"
    else
      raw "#{canonical_protocol}#{host}#{path_without_html_extension}#{trailing_slash_config(force_trailing_slash)}#{allowed_query_string}"
    end
  end
end
require 'uri'
require 'pp'

# Extracts scheme, host, path, path steps (as an array), and query parameters from a URL string.
#
# @param url_string [String] The URL to parse.
# @return [Hash] A hash containing :scheme, :host, :path, :path_steps (Array), and :query_params (Hash).
#                Returns nils/empty defaults if the URL is invalid or lacks components.
def extract_url_parts(url_string)
  parts = { scheme: nil, host: nil, path: nil, path_steps: [], query_params: {} }
  begin
    uri = URI.parse(url_string)
    parts[:scheme] = uri.scheme
    unless uri.host && parts[:scheme]
      # If there is no schema, won't be treated as valid URL
      puts "Schema required ex: http:// or https://"
      return { scheme: nil, host: nil, path: nil, path_steps: [], query_params: {} }
    end

    parts[:host] = uri.host
    path_string = (uri.path.nil? || uri.path.empty?) ? '/' : uri.path
    parts[:path] = path_string
    parts[:path_steps] = path_string.split('/').reject(&:empty?)
    if uri.query
      parts[:query_params] = URI.decode_www_form(uri.query).to_h
    end

  rescue URI::InvalidURIError => e
    puts "Warning: Invalid URL provided - '#{url_string}'. Error: #{e.message}"
    # If the input URL is not valid, will print the trace and return empty hash
    return { scheme: nil, host: nil, path: nil, path_steps: [], query_params: {} }
  end

  parts
end


# Composes a new URL based on original data and filter options.
#
# @param url_data [Hash] The hash from extract_url_parts (should include :scheme, :host, :path_steps, :query_params).
# @param filter_options [Hash] Options specifying modifications:
#   :keep_query_params [Array<String>, nil] Keys of query parameters to retain.
#                                            - nil: Keep all original query parameters.
#                                            - []: Keep no query parameters.
#                                            - Array: Keep only parameters whose keys are in the array.
#   :keep_path_steps [Array<String>, nil] Values of path steps to retain. Order is preserved from original path.
#                                            - nil: Keep all original path steps.
#                                            - []: Keep no path steps (results in root path '/').
#                                            - Array: Keep only original steps whose values are in the array.
#   :new_host [String, nil] Optional new host. If provided (and not empty), replaces the original host.
#
# @return [Hash] A hash containing the processed :scheme, :host, :path, :path_steps, :query_params,
#                and the resulting reconstructed :processed_url string (or nil if a host is unavailable).
def compose_filtered_url(url_data, filter_options)
  original_scheme = url_data[:scheme]
  original_host = url_data[:host]
  original_path_steps = url_data[:path_steps] || []
  original_query_params = url_data[:query_params] || {}
  keep_query_params_filter = filter_options[:keep_query_params]
  keep_path_steps_filter = filter_options[:keep_path_steps]
  new_host_option = filter_options[:new_host]
  processed_host = new_host_option && !new_host_option.strip.empty? ? new_host_option.strip : original_host
  processed_scheme = original_scheme
  if processed_scheme.nil? && processed_host
    processed_scheme = 'https' # Default scheme assumption
  end

  processed_path_steps = case keep_path_steps_filter
                         when nil
                           original_path_steps
                         when []
                           []
                         else
                           # Keep original steps included in the filter, maintaining original order
                           original_path_steps.select { |step| keep_path_steps_filter.include?(step) }
                         end

  processed_path = processed_path_steps.empty? ? "/" : "/" + processed_path_steps.join('/')
  processed_query_params = case keep_query_params_filter
                           when nil
                             original_query_params
                           when []
                             {}
                           else
                             # Keep original params whose keys are in the filter list
                             original_query_params.select { |key, _value| keep_query_params_filter.include?(key) }
                           end

  # Use URI.encode_www_form to correctly format the query string
  processed_query_string = URI.encode_www_form(processed_query_params)

  processed_url = nil
  # We need a scheme and host to build an absolute URL
  if processed_scheme && processed_host
    processed_url = "#{processed_scheme}://#{processed_host}#{processed_path}"
    processed_url += "?#{processed_query_string}" unless processed_query_string.empty?
  end

  {
    scheme: processed_scheme,
    host: processed_host,
    path: processed_path,
    path_steps: processed_path_steps,
    query_params: processed_query_params,
    processed_url: processed_url
  }
end

require_relative 'url_parser'

puts "\n RUBY URL PARSER \n\n"
url_to_parse = "https://example.com/products/123/variants/45?ref=email&source=campaign&color=blue"
puts "Original URL String: #{url_to_parse}"
parsed_data = extract_url_parts(url_to_parse)
# Define your filter options
options = {
  keep_query_params: ["ref", "color"],
  keep_path_steps: ["products"],
}

# Call the function
processed_result = compose_filtered_url(parsed_data, options)

# The result includes the modified parts and the final URL string
puts "\nProcessed URL Data:"

# You can directly access the recomposed URL string
puts "\nCleaned URL: #{processed_result[:processed_url]}"
url_string = "https://www.ruby_url_parser.com/users/123/orders/456/details?session=abc&theme=dark&lang=en&page=1"
puts "\n\nOriginal URL String: #{url_string}"
original_data = extract_url_parts(url_string)


filters = {
  keep_query_params: [],                   # Keep no query params
  keep_path_steps: ["users", "123"],     # Keep only first two path steps
  new_host: "ruby_parser.app"
}
processed_result2 = compose_filtered_url(original_data, filters)
# pp processed_result2 # For showing hashmap
puts "\nCleaned URL2: #{processed_result2[:processed_url]}"
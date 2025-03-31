# Url Parser

## Version 0.1

## Overview

The code provides two main functions:
1.  `extract_url_parts`: Parses a URL string into its components (scheme, host, path steps, query parameters).
2.  `compose_filtered_url`: Reconstructs a URL string based on potentially modified components, allowing filtering of path steps and query parameters, and overriding the host.

## Features

Okay, here is the list of possible usages for the URL parser functions, formatted in Markdown:

## URL Parser Use Cases 
###### This list has been generated by Gemini 2.5 passing the code

### 1. Data Extraction & Analysis

* **Domain/Host Analysis:** Extracting just the hostname (`:host`) from a list of URLs to categorize traffic sources, identify unique domains, or analyze link partnerships.
* **Tracking Parameter Extraction:** Isolating specific query parameters (`:query_params`) like UTM tags (`utm_source`, `utm_medium`, `utm_campaign`, `utm_term`, `utm_content`) from marketing URLs for campaign performance analysis.
* **API Versioning Analysis:** Identifying the API version used in requests by extracting it from the path segments (`:path_steps`), e.g., identifying `v1`, `v2` in `/api/v1/users`.
* **Resource Identification:** Extracting specific identifiers (like user IDs, product IDs, order numbers) from path segments (`:path_steps`), e.g., getting `123` and `456` from `/users/123/orders/456`.
* **Content Type Analysis:** Determining the type of content based on path structure (e.g., identifying blog posts via `/blog/`, product pages via `/products/`).
* **Query Parameter Usage Reporting:** Counting the frequency or analyzing the values of specific query parameters across many URLs.

### 2. URL Manipulation & Normalization

* **Canonical URL Generation:** Creating a standard URL representation for SEO or caching purposes by:
    * Removing specific unwanted query parameters (e.g., session IDs, tracking tags) using `:keep_query_params`.
    * Sorting remaining query parameters alphabetically (requires extra logic after parsing).
    * Ensuring a consistent scheme (e.g., always `https`).
    * Removing default filenames (e.g., `index.html`).
    * Standardizing paths (e.g., removing or adding trailing slashes).
* **Parameter Filtering/Stripping:** Removing sensitive information or irrelevant parameters using the `:keep_query_params` filter before logging, storing, or sharing URLs.
* **Adding/Modifying Query Parameters:** Appending necessary parameters or modifying existing ones before making a request or generating a link (requires slight extension to `compose_filtered_url` logic for *adding* new params).
* **Host/Scheme Redirection:** Generating redirect URLs by changing the host using `:new_host` or scheme (e.g., migrating users from `http` to `https` or from an old domain to a new one) while preserving relevant path and query information.
* **Simplifying URLs for Display:** Creating shorter, cleaner URLs for display by removing verbose tracking parameters or intermediate path segments using the filter options.

### 3. Routing & Dispatching (e.g., in Web Frameworks)

* **Request Routing:** Matching incoming request URLs against predefined route patterns based on path segments (`:path_steps`) to determine which code (controller/action) should handle the request.
* **Parameter Extraction for Controllers:** Extracting values from path segments (e.g., `:id` from `/users/:id`) or query parameters (`:query_params`) to be used as input for backend logic.

### 4. Validation & Verification

* **Host Validation:** Checking if a URL's `:host` belongs to an allowed list (whitelist) before processing it, performing redirects, or making requests.
* **Redirect Validation:** Ensuring that a redirect URL target (extracted via parsing) points to a trusted domain to prevent open redirect vulnerabilities.
* **Structure Validation:** Verifying if a URL path conforms to an expected pattern using `:path_steps` (e.g., `/resource/<numeric_id>/action`).
* **Parameter Presence Check:** Ensuring required query parameters exist in `:query_params`.

### 5. Web Scraping & Crawling

* **Scope Control:** Extracting the `:scheme` and `:host` to ensure the crawler stays within the target website and doesn't follow external links unintentionally.
* **Relative URL Resolution:** Constructing absolute URLs from relative links found on a page by combining them with the base URL's `:scheme`, `:host`, and base `:path`.
* **Link Analysis:** Categorizing links found on a page based on their structure (e.g., internal vs. external, links to specific sections).

## Prerequisites

* A working installation of Ruby (2.5 or newer is recommended, tested in Ruby 3.2.2 on Windows 11).

## Setup

Just run ensure that you have `url_parser.rb` in your project folder

Now you can call the functions `extract_url_parts` and `compose_filtered_url` from `url_parser.rb`.

## Usage

A script that does two different usages for the URL Parser

```ruby
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
  keep_query_params: [], # Keep no query params
  keep_path_steps: ["users", "123"], # Keep only first two path steps
  new_host: "ruby_parser.app"
}
processed_result2 = compose_filtered_url(original_data, filters)
# pp processed_result2 # Uncomment for showing the hashmap
puts "\nCleaned URL2: #{processed_result2[:processed_url]}"
```

## TODOs

- Test it in other OS
- Write unit tests for the parser
- Build a Ruby gem
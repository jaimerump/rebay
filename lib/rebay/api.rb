require 'net/http'
require 'json'
require 'uri'

module Rebay
  class Api
    # default site is EBAY_US, for other available sites see eBay documentation:
    # http://developer.ebay.com/DevZone/merchandising/docs/Concepts/SiteIDToGlobalID.html
    COUNTRY_MAPPINGS = { 'United States' => { :global_id => "EBAY-US", :site_id => 0 },
                         'United Kingdom' => { :global_id => "EBAY-UK", :site_id => 3 },
                         'Australia' => { :global_id =>"EBAY-AU", :site_id => 15 },
                         'Austria' => { :global_id => "EBAY-AT", :site_id => 16 },
                         'Canada' => { :global_id =>"EBAY-ENCA", :site_id => 2 },
                         'Canada (French)' => { :global_id => "EBAY-FRCA", :site_id => 210 },
                         'Switzerland' => { :global_id =>"EBAY-CH", :site_id => 193 },
                         'Belguim (French)' => { :global_id => "EBAY-FRBE", :site_id => 23 },
                         'Belguim (Dutch)' => { :global_id => "EBAY-NLBE", :site_id => 123 },
                         'Germany' => { :global_id => "EBAY-DE", :site_id => 77 },
                         'Spain' => { :global_id => "EBAY-ES", :site_id => 189 },
                         'France' => { :global_id => "EBAY-FR", :site_id => 71 },
                         'Ireland' => { :global_id => "EBAY-IE", :site_id => 205 },
                         'India' => { :global_id => "EBAY-IN", :site_id => 203 },
                         'Italy' => { :global_id => "EBAY-IT", :site_id => 101 },
                         'Netherlands' => { :global_id => "EBAY-NL", :site_id => 146 },
                         'Hong Kong' => { :global_id => "EBAY-HK", :site_id => 201 },
                         'Malaysia' => { :global_id => "EBAY-MY", :site_id => 207 },
                         'Philippines' => { :global_id => "EBAY-PH", :site_id => 211 },
                         'Poland' => { :global_id => "EBAY-PL", :site_id => 212 },
                         'Singapore' => { :global_id => "EBAY-SG", :site_id => 216 }
                        }

    EBAY_US = COUNTRY_MAPPINGS['United States'][:site_id]

    class << self
      attr_accessor :app_id, :default_site_id, :default_global_id, :sandbox
      
      def base_url
        [base_url_prefix,
         sandbox ? "sandbox" : nil,
         base_url_suffix].compact.join('.')
      end

      def base_url_prefix
        "http://svcs"
      end

      def base_url_suffix
        "ebay.com"
      end

      def sandbox
        @sandbox ||= false
      end
      
      def default_site_id
        @default_site_id || COUNTRY_MAPPINGS['United States'][:site_id]
      end

      def default_global_id
        @default_global_id || COUNTRY_MAPPINGS['United States'][:global_id]
      end
      
      def configure
        yield self if block_given?
      end
    end

    protected
    
    def get_json_response(url)
      Rebay::Response.new(JSON.parse(Net::HTTP.get_response(URI.parse(url)).body))
    end

    def build_rest_payload(params)
      payload = ''
      unless params.nil?
        params.keys.each do |key|
          payload += URI.escape "&#{key}=#{params[key]}"
        end
      end
      return payload
    end
  end
end

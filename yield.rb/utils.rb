require 'bigdecimal'

module Utils
  class << self
    def http_get(uri)
      uri = URI(uri)
      res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Get.new(uri)
        req["Content-Type"] = "application/json"

        http.request(req)
      end

      res.body
    end

    def http_post(uri, data)
      uri = URI(uri)
      res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Post.new(uri)
        req["Content-Type"] = "application/json"
        req.body = data.to_json

        http.request(req)
      end

      res.body
    end

    def binance_http_get(api_uri, api_key, secret_key)
      timestamp = Time.now.to_i * 1000
      params = "timestamp=#{timestamp}"
      signature = OpenSSL::HMAC.hexdigest("sha256", secret_key, params)
      params = "#{params}&signature=#{signature}"
      uri = URI("#{api_uri}?#{params}")

      res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Get.new(uri)
        req["X-MBX-APIKEY"] = api_key

        http.request(req)
      end

      res.body
    end

    def round(value, rounding_setting)
      BigDecimal(value.to_s).round(rounding_setting).to_s("F")
    end

    def token_name(name)
      case name
      when "beltBNB", "iBNB", "WBNB"
        "BNB"
      when "beltBTC", "BTCB", "WBTC"
        "BTC"
      when "beltETH", "WETH"
        "ETH"
      when "WMATIC"
        "MATIC"
      when "PAUTO"
        "AUTO"
      when "IRON", "IS3USD"
        "USDC"
      else
        name
      end
    end
  end
end

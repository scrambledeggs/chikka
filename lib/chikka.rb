require 'rubygems'
require 'net/http'
require 'securerandom'

module Chikka

  class Error < StandardError; end

  class BadRequestError < Error; end

  class AuthenticationError < Error; end

  class Response
    attr_reader :status, :message, :description, :message_id
    def initialize(http_response, message_id)
      r = JSON.parse(http_response.body)
      @status = r['status']
      @message = r['message']
      @description = r['description']
      @message_id = message_id
    end
  end

  class Client
    attr_accessor :client_id, :secret_key, :shortcode, :http
    SMSAPI_PATH = '/smsapi/request'
    DEFAULT_PARAMS = {}
    def initialize(options = {})
      @client_id= options.fetch(:client_id) { ENV.fetch('CHIKKA_CLIENT_ID') }
      @secret_key = options.fetch(:secret_key) { ENV.fetch('CHIKKA_SECRET_KEY') }
      @shortcode = options.fetch(:shortcode) { ENV.fetch('CHIKKA_SHORTCODE') }
      @mask = options.fetch(:mask) { ENV.fetch('CHIKKA_MASK') } if ENV.has_key?('CHIKKA_MASK') || options.has_key?(:mask)

      # @host = options.fetch(:host) { 'post.chikka.com' }
      @host = options.fetch(:host)
      @http = Net::HTTP.new(@host, Net::HTTP.https_default_port)
      @http.use_ssl = true

      DEFAULT_PARAMS[:client_id] = @client_id
      DEFAULT_PARAMS[:secret_key] = @secret_key
      DEFAULT_PARAMS[:shortcode] = @shortcode
      DEFAULT_PARAMS[:mask] = @mask
    end

    def send_message(params = {})
      params[:message_id] = params.fetch(:message_id) { generate_message_id }

      message_type = "SEND"
      if params[:request_id]
        message_type = "REPLY"
        params[:request_cost] = params.fetch(:resquest_cost) { "FREE" }
      end

      post_params = DEFAULT_PARAMS.merge({
        message_type: message_type
      }.merge(params))

      body = URI.encode_www_form(post_params)
      parse(@http.post(SMSAPI_PATH, body, {'Content-Type' => 'application/x-www-form-urlencoded'}), params[:message_id])
    end

    private
      def generate_message_id
        SecureRandom.hex
      end

      def parse(http_response, message_id)
        response_obj = Response.new(http_response, message_id)
        case response_obj.status
        when 200
          response_obj
        when 401
          raise AuthenticationError.new(message= response_obj.description)
        when 400
          raise BadRequestError.new(message = response_obj.description)
        else
          raise Error.new(message=response_obj.description)
        end
      end
  end
end

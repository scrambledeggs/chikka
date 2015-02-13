require 'rubygems'
require 'net/http'
require 'securerandom'

module Chikka

  class Error < StandardError; end

  class IncompleteParametersError < Error; end

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

      @host = options.fetch(:host) { 'post.chikka.com' }
      @http = Net::HTTP.new(@host, Net::HTTP.https_default_port)
      @http.use_ssl = true

      DEFAULT_PARAMS[:client_id] = @client_id
      DEFAULT_PARAMS[:secret_key] = @secret_key
      DEFAULT_PARAMS[:shortcode] = @shortcode
    end

    def send_message(params = {})
      message_id = params.fetch(:message_id) { generate_message_id }
      post_params = DEFAULT_PARAMS.merge({
        message_type: "SEND",
        mobile_number: params[:mobile_number],
        message: params[:message],
        message_id: message_id
      })
      body = URI.encode_www_form(post_params)
      parse(@http.post(SMSAPI_PATH, body, {'Content-Type' => 'application/x-www-form-urlencoded'}), message_id)
    end

    def send_reply(params = {})
      message_id = params.fetch(:message_id) { generate_message_id }
      request_cost = params.fetch(:request_cost) { "FREE" }
      post_params = DEFAULT_PARAMS.merge({
        message_type: "REPLY",
        mobile_number: params[:mobile_number],
        message: params[:message],
        message_id: message_id,
        request_id: params[:request_id],
        request_cost: request_cost
      })
      body = URI.encode_www_form(post_params)
      parse(@http.post(SMSAPI_PATH, body, {'Content-Type' => 'application/x-www-form-urlencoded'}), message_id)
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
        when 400
          raise IncompleteParametersError.new(message="#{response_obj.message} HTTP_RESP: #{response_obj.description}")
        when 401
          raise AuthenticationError.new(message="#{response_obj.message} HTTP_RESP: #{response_obj.description}")
        else
          raise Error.new(message="#{response_obj.message} HTTP_RESP: #{response_obj.description}")
        end
      end
  end
end
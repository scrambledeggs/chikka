require 'minitest/autorun'
# require 'webmock/minitest'
require 'chikka'
require 'json'

describe 'Chikka::Client' do
  before do
    @smsapi_url = "https://post.chikka.com/smsapi/request'"
    @form_urlencoded_data = {body: /(.+?)=(.+?)(&(.+?)=(.+?))+/, headers: {'Content-Type' => 'application/x-www-form-urlencoded'}}
    # @client = Chikka::Client.new(client_id:'key', secret_key:'secret', shortcode:'shortcode')
    # @client = Chikka::Client.new()
    @client = Chikka::Client.new(client_id: 'ec4f59fb671e8d7437e508da497683f1d5a230ab104f300a29d77e7ffc7b1e52',
  secret_key:'7ef5fc22cb9131954ec54d9e2a13c0a274217c9eefc8fd00c02f82f0baad0d4b',
  shortcode:'2929026659')
  end

  describe 'http method' do
    it 'returns a net http object that uses ssl' do
      @client.http.must_be_instance_of(Net::HTTP)

      @client.http.use_ssl?.must_equal(true)
    end
  end

  describe 'send_message method' do
    it 'must be able to post a message to chikka' do
      response_obj = @client.send_message(message:'This is a test', mobile_number:'639175018430')
      response_obj.status.must_equal 200
      response_obj.message.must_equal "ACCEPTED"
    end

    describe 'errors' do
      it 'must raise an error when mobile number is not supplied ' do
        proc{
          response_obj = @client.send_message(message:'This is a test') #no mobile number
        }.must_raise(Chikka::IncompleteParametersError)
      end

      it 'must raise an error when message is not supplied ' do
        proc{
          response_obj = @client.send_message(mobile_number:'639175018430') #no message
        }.must_raise(Chikka::IncompleteParametersError)
      end

      it 'must raise an error when client_id is not supplied or invalid' do
        proc{
          client = Chikka::Client.new(client_id:'illegal')
          response_obj = @client.send_message(mobile_number:'639175018430', message: 'This is a test')
        }.must_raise(Chikka::AuthenticationError)
      end

      it 'must raise an error when secret_key is not supplied or invalid' do
        proc{
          client = Chikka::Client.new(secret_key:'illegal')
          response_obj = @client.send_message(mobile_number:'639175018430', message: 'This is a test')
        }.must_raise(Chikka::AuthenticationError)
      end
    end
  end

  describe 'send reply method' do
    it "must be tested" do
    end
  end
end
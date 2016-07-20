require 'minitest/autorun'
# require 'webmock/minitest'
require 'chikka'
require 'json'

describe 'Chikka::Client' do
  before do
    @smsapi_url = "https://post.chikka.com/smsapi/request'"
    @form_urlencoded_data = {body: /(.+?)=(.+?)(&(.+?)=(.+?))+/, headers: {'Content-Type' => 'application/x-www-form-urlencoded'}}
    # @client = Chikka::Client.new(client_id:'key', secret_key:'secret', shortcode:'shortcode')
    @client = Chikka::Client.new()
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
    end
  end

  describe 'send reply method' do
    it "must be tested" do
    end
  end
end
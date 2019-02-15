RSpec.describe Todoable do
  describe Todoable::Session do
    # NOTE: Typically I would set username and password in a config file instead of exposing it.
    let (:username) { 'andyywz@gmail.com' }
    let (:password) { 'todoable' }
    let (:url) { 'http://todoable.teachable.tech/api/authenticate' }
    let (:list_url) { 'http://todoable.teachable.tech/api/lists' }
    let (:headers) { { content_type: :json, accept: :json } }

    it 'creates a Todoable::Session' do
      VCR.use_cassette('session') do
        session = Todoable::Session.new(username, password)
        expect(session).to be_an_instance_of(Todoable::Session)
      end
    end

    it 'authenticates the user' do
      expect_any_instance_of(Todoable::Session).to receive(:authenticate)

      Todoable::Session.new('fakeuser', 'fakepassword')
    end

    describe '.authenticate' do
      context 'when authentication succeeds' do
        it 'sets a token and token expiry' do
          VCR.use_cassette('authenticate') do
            session = Todoable::Session.new(username, password)

            expect(session.token).to be_truthy
            expect(session.token_expiry).to be_truthy
          end
        end
      end

      context 'when authentication fails' do
        it 're-raises the error' do
          stub_post = stub_request(:post, url).to_raise(RestClient::Unauthorized.new)

          expect do
            Todoable::Session.new('bad', 'user')
          end.to raise_error(RestClient::Unauthorized)

          remove_request_stub(stub_post)
        end
      end
    end

    describe '.invoke' do
      it 'authenticates the token' do
        VCR.use_cassette('invoke_auth') do
          session = Todoable::Session.new(username, password)

          expect_any_instance_of(Todoable::Session).to receive(:authenticate)
          session.invoke(:get, list_url)
        end
      end

      context 'when the request succeeds' do
        it 'returns the response body' do
          VCR.use_cassette('invoke_success') do
            session = Todoable::Session.new(username, password)

            response = session.invoke(:get, list_url)
            expect(response).to be_an_instance_of(String)
          end
        end
      end

      context 'when the request is unprocessable' do
        it 're-raises the error' do
          twenty_minutes_from_now = Time.now + 20 * 60
          fake_auth_res = OpenStruct.new(
            body: {
              token: 'fake',
              expires_at: twenty_minutes_from_now
            }.to_json
          )

          stub_auth = stub_request(:post, url).to_return(fake_auth_res)
          stub_get = stub_request(:post, list_url).to_raise(RestClient::UnprocessableEntity.new)

          session = Todoable::Session.new(username, password)

          expect do
            session.invoke(:post, list_url, 'fake payload')
          end.to raise_error(RestClient::UnprocessableEntity)

          WebMock.reset!
        end
      end
    end
  end
end

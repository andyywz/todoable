RSpec.describe Todoable do
  describe Todoable::Session do
    # NOTE: Typically I would set user and password in a config file instead of exposing it.
    let (:user)     { 'andyywz@gmail.com' }
    let (:password) { 'todoable' }
    let (:url)      { 'http://todoable.teachable.tech/api/authenticate' }
    let (:list_url) { 'http://todoable.teachable.tech/api/lists' }
    let (:session)  { Todoable::Session.new(user, password) }

    it 'sets the user and password on initialization' do
      expect(session.user).to eq(user)
      expect(session.password).to eq(password)
    end

    describe '#authenticate' do
      context 'when authentication succeeds' do
        it 'returns the token' do
          VCR.use_cassette('authenticate') do
            token = session.authenticate

            expect(token).to be_an_instance_of(String)
          end
        end

        it 'sets the token and token expiry' do
          VCR.use_cassette('authenticate') do
            token = session.authenticate

            expect(session.token).to eq(token)
            expect(session.token_expiry).to be_truthy
          end
        end
      end

      context 'when authentication fails' do
        it 'raises a user unauthorized the error' do
          stub_request(:post, url).to_raise(RestClient::Unauthorized.new)
          bad_session = Todoable::Session.new('bad', 'user')

          expect do
            @error = bad_session.authenticate
          end.to raise_error(Todoable::Exceptions::UserUnauthorized)

          WebMock.reset!
        end
      end

      context 'when a token is still valid' do
        it 'returns the current token' do
          fake_session = Todoable::Session.new('authed_user', 'fake')
          fake_session.token = 'fake-token'
          fake_session.token_expiry = Time.now + 60 # expiring a minute from now

          token = fake_session.authenticate

          expect(token).to eq(fake_session.token)
        end
      end
    end

    describe '#invoke' do
      context 'when a token is not present' do
        it 'raises a user unauthorized error' do
          expect do
            session.invoke(:get, url)
          end.to raise_error(Todoable::Exceptions::UserUnauthorized)
        end
      end

      context 'when a token is expired' do
        it 're-authenticates' do
          VCR.use_cassette('invoke_auth') do
            session.token = 'fake-token'
            session.token_expiry = Time.now - 1000

            expect_any_instance_of(Todoable::Session).to receive(:authenticate).and_call_original
            session.invoke(:get, list_url)
          end
        end
      end

      context 'when the invoked request succeeds' do
        it 'returns the response body' do
          VCR.use_cassette('invoke_success') do
            session.authenticate
            response = session.invoke(:get, list_url)
            expect(response).to be_an_instance_of(String)
          end
        end
      end

      context 'when the request is unprocessable' do
        it 're-raises the original error' do
          VCR.use_cassette('invoke_failure') do
            session.authenticate
            stub_request(:post, list_url).to_raise(RestClient::UnprocessableEntity.new)

            expect do
              session.invoke(:post, list_url, 'fake payload')
            end.to raise_error(RestClient::UnprocessableEntity)

            WebMock.reset!
          end
        end
      end
    end
  end
end

RSpec.describe Todoable do
  describe Todoable::Session do
    let (:username) { 'test' }
    let (:password) { 'password' }
    let (:url) { 'http://todoable.teachable.tech/api/authenticate' }
    let (:payload) { { username: username, password: password }.to_json }
    let (:headers) { { content_type: :json, accept: :json } }

    it 'creates a Todoable::Session' do
      allow(RestClient).to receive(:post)
        .with(url, payload, headers)
        .and_return(OpenStruct.new(body: { token: 'fake-token' }.to_json))

      session = Todoable::Session.new(username, password)
      expect(session).to be_an_instance_of(Todoable::Session)
    end

    it 'authenticates the user' do
      expect_any_instance_of(Todoable::Session).to receive(:authenticate)

      Todoable::Session.new(username, password)
    end

    describe '.authenticate' do
      context 'when authentication succeeds' do
        it 'returns a token' do
          allow(RestClient).to receive(:post)
            .with(url, payload, headers)
            .and_return(OpenStruct.new(body: { token: 'fake-token' }.to_json))

          session = Todoable::Session.new(username, password)
          token = session.authenticate
          expect(token).to eq('fake-token')
        end
      end

      context 'when authentication fails' do
        xit 'raises an error' do

        end

        xit 'returns nil' do

        end
      end
    end

    describe '.invoke' do
      xit 'authenticates the token' do
      end

      xit 'executes a RestClient::Request' do
      end

      context 'when the request succeeds' do
        xit 'returns a json response' do
        end
      end

      context 'when the request fails' do
        xit 'raises an error' do
        end

        xit 'returns nil'
      end
    end
  end
end

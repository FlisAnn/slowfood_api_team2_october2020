RSpec.describe 'POST "/api/auth" ', type: :request do
  let(:headers) { { HTTP_ACCPT: 'application/json' } }

  describe 'with valid credentials' do
    before do
      post '/api/auth',
        params: {
          email: 'user@mail.com',
          password: 'password',
          password_confirmation: 'password'
        },
        headers: headers
    end

    it 'returns a 200 response status' do
      expect(response).to have_http_status 200
    end

    it 'return a success message' do
      expect(response_json['status']).to eq 'success'
    end
  end

  context 'when a user submits' do
    describe 'a non-matching password confirmation' do
      before do
        post '/api/auth',
          params: {
            email: 'user@mail.com',
            password: 'password',
            password_confirmation: 'wrong_password'
          },
          headers: headers
    end

    it 'returns a 422 response' do
      expect(response).to have_http_status 422
    end

    it 'returns an error message' do
      expect(response_json['errors']['password_confirmation']).to eq ["doesn't match Password"]
    end
  end

    describe 'an invalid email address' do
      before do
        post '/api/auth',
          params: {
            email: 'user@mail.',
            password: 'password',
            password_confirmation: 'password'
          },
          headers: headers
      end

      it 'return a 422 response status' do
        expect(response).to have_http_status 422
      end

      it 'return an error message' do
        expect(response_json['errors']['email']).to eq ['is not an email']
      end
    end

    describe 'an already registered email' do
      let!(:registered_user) { create(:user, email: 'coach@mail.com' ) }

      before do
        post '/api/auth',
          params: {
            email: 'coach@mail.com',
            password: 'password',
            password_confirmation: 'password'
          },
          headers: headers
      end

      it 'returns a 422 response status' do
        expect(response).to have_http_status 422
      end

      it 'returns an error message' do
        expect(response_json['errors']['email']).to eq ['has already been taken']
      end
    end
  end
end
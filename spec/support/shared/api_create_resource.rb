require 'rails_helper'

shared_examples_for 'API create resource' do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:klass) { resource.to_s.downcase.to_sym }

  context 'with invalid attributes' do
    it 'returns negative response' do
      do_request(method, api_path, params: { klass => attributes_inv, access_token: token }, headers: headers)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'does not save the resource' do
      expect {
        do_request(method, api_path, params: { klass => attributes_inv, access_token: token }, headers: headers)
      }.to_not change(resource, :count)
    end
  end

  context 'with valid attributes' do
    it 'returns successful response' do
      do_request(method, api_path, params: { klass => attributes, access_token: token }, headers: headers)
      expect(response).to be_successful
    end

    it 'saves a new resource in the database' do
      expect {
        do_request(method, api_path, params: { klass => attributes, access_token: token }, headers: headers)
      }.to change(resource, :count).by(1)
    end

    it 'saves with correct author' do
      do_request(method, api_path, params: { klass => attributes, access_token: access_token.token }, headers: headers)

      expect(assigns(klass).user_id).to eq attributes[:user_id]
    end

    it 'saves with correct attributes' do
      do_request(method, api_path, params: { klass => attributes, access_token: access_token.token }, headers: headers)

      expect(assigns(klass).body).to eq attributes[:body]
    end
  end
end

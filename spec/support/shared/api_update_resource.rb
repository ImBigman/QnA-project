require 'rails_helper'

shared_examples_for 'API update resource' do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:klass) { resource.to_s.downcase.to_sym }

  context 'with invalid attributes' do
    before do
      do_request(method, api_path, params: { id: instance.id, klass => attributes_inv, access_token: token }, headers: headers)
      assigns(klass).reload
    end

    it 'returns negative response' do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'does not update the resource' do
      expect(assigns(klass).body).to_not eq attributes_inv[:body]
      expect(assigns(klass).body).to eq instance.body
    end
  end

  context 'with valid attributes' do
    before do
      do_request(method, api_path, params: { id: instance.id, klass => attributes, access_token: token }, headers: headers)
      assigns(klass).reload
    end

    it 'returns successful response' do
      expect(response).to be_successful
    end

    it 'saves updated resource in the database' do
      expect(assigns(klass).body).to eq attributes[:body]
    end

    it 'saves with correct author' do
      expect(assigns(klass).user_id).to eq attributes[:user_id]
    end

    it 'saves with correct attributes' do
      expect(assigns(klass).body).to eq attributes[:body]
    end
  end
end

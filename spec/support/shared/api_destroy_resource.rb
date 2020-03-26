require 'rails_helper'

shared_examples_for 'API destroy resource' do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:klass) { resource.to_s.downcase.to_sym }

  it 'returns successful response' do
    do_request(method, api_path, params: { id: instance.id, klass => attributes, access_token: token }, headers: headers)
    expect(response).to be_successful
  end

  it 'delete resource from database' do
    expect {
      do_request(method, api_path, params: { id: instance.id, klass => attributes, access_token: token }, headers: headers)
    }.to change(resource, :count).by(-1)
  end
end

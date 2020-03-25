require 'rails_helper'

shared_examples_for 'API resource contains' do
  it 'contains user object' do
    expect(resource_response['user']['id']).to eq instance.user.id
  end

  it 'contains comments object' do
    expect(resource_response['comments'].first['id']).to eq instance.comments.first.id
  end

  it 'contains links object' do
    expect(resource_response['links'].first['id']).to eq instance.links.first.id
  end

  it 'contains files object' do
    expect(resource_response['files'].first['id']).to eq instance.files.first.id
  end

  it 'contains files url' do
    expect(resource_response['files'].first['url']).to eq rails_blob_path(instance.files.first, only_path: true)
  end
end

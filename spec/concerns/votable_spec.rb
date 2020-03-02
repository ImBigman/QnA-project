require 'spec_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }
end


require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#github' do
    let(:oath_data) { { 'provider': 'github', 'uid': 123 } }

    it 'finds user from auth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oath_data)

      expect(User).to receive(:find_for_oauth).with(oath_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exists' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end
  describe '#vkontakte' do
    let(:oath_data) { { 'provider': 'vkontakte', 'uid': 321 } }

    it 'finds user from auth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oath_data)

      expect(User).to receive(:find_for_oauth).with(oath_data)
      get :vkontakte
    end

    context 'user exists without real email' do
      let!(:user) { create(:user, email: 'uid_321@email.com') }

      it 'render email confirmation template' do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :vkontakte

        expect(response).to render_template('confirmations/email')
      end
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :vkontakte
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exists' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :vkontakte
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end
end

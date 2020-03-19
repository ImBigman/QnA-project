class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid)
    return authorization.user if authorization

    user = User.find_by(email: email(auth))
    if user
      user.authorizations.create!(provider: auth.provider, uid: auth.uid)
      user
    else
      create_user!(auth)
    end
  end

  private

  def email(auth)
    if auth.info[:email].blank?
      "uid_#{auth.uid}@email.com"
    else
      auth.info[:email]
    end
  end

  def create_user!(auth)
    password = Devise.friendly_token[0, 20]

    if email(auth).include?('uid_')
      user = User.new(email: email(auth), password: password, password_confirmation: password)
      user.skip_confirmation_notification!
      user.save
    else
      user = User.create!(email: email(auth), password: password, password_confirmation: password)
    end

    Authorization.transaction do
      user.authorizations.create!(provider: auth.provider, uid: auth.uid)
    end

    user
  end
end

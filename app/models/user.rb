class User < ActiveRecord::Base
  attr_reader :password

  after_initialize :ensure_session_token

  has_many :cats,

  validates :username, presence: true, uniqueness: true
  validates :session_token, presence: true, uniqueness: true
  validates :pasword, length: { minimum: 6, allow_nil: true }
  validates :password_digest presence: { message: "Password can not be blanck" }

  def generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)

  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)

  end

  def find_by_credentials(username, password)
    #User.find_by(username: username)
    user = User.find_by_username(username)

    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  private
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

end

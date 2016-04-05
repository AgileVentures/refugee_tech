class User < ApplicationRecord
  include Amistad::FriendModel
  acts_as_token_authenticatable
  extend FriendlyId
  friendly_id :user_name, use: [:slugged, :finders]

  acts_as_taggable_on :skills
  acts_as_messageable

  has_many :user_languages
  has_many :languages, through: :user_languages

  after_validation :reverse_geocode, if: lambda{ |obj| obj.latitude.present? || obj.longitude.present? }
  after_validation :geocode, if: lambda{ |obj| obj.ip_address.present? }
  
  validates :gender,
    inclusion: { in: [ 'Male', 'Female', 'male', 'female', nil ],
    message: "%{value} is not a valid gender" }

  validates_length_of :introduction, maximum: 140, message: "Maximum length is 140 characters"

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  default_scope { where(private: false) }
  scope :private_profiles, -> { unscoped.where(private: true) }
  scope :all_profiles, -> { unscoped }
  scope :mentors, -> { where(mentor: true) }
  scope :mentorees, -> { where(mentor: false) }

  def to_s
    user_name
  end

  def unify
    self.mentor ? self.find_related_skills.mentorees : self.find_related_skills
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,10]
      user.user_name = auth.info.name
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end


  def reset_authentication_token
    self.update_attribute(:authentication_token, nil)
  end
  
  reverse_geocoded_by :latitude, :longitude, address: :location do |obj,results|
    if geo = results.first
      obj.city     = geo.city
      obj.state    = geo.state
      obj.country  = geo.country
    end
  end
  
  geocoded_by :ip_address do |obj,results|
    if geo = results.first
      obj.city     = geo.city
      obj.state    = geo.state
      obj.country  = geo.country
    end
  end

  def mailboxer_name
    self.user_name
  end

  def mailboxer_email(object)
    self.email
  end

  def messages_count
    #Rails 5 error with .count(:id, distinct: true)
    self.mailbox.conversations.distinct.count(:id)
  end

  def unread_messages_count
    #Rails 5 error with .count(:id, distinct: true)
    self.mailbox.conversations(unread: true).distinct.count(:id)
  end
  
  private
  
  def address
    [city, state, country].compact.join(', ')
  end
  
end

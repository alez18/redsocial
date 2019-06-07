# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  username               :string           default(""), not null
#  name                   :string
#  last_name              :string
#  bio                    :text
#  uid                    :string
#  provider               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_reader :password
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  validates :username, presence: true, uniqueness: true, length: {in: 3..12}
  validate :validate_username_regex

  has_attached_file :avatar, styles:{ thumb: "100x100" , medium: "300x300" }, default_url: "/images/:style/missing.jpg"
  has_attached_file :cover, styles:{ thumb: "400x300" , medium: "800x600" }, default_url: "/images/:style/missing_cover.jpg"

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates_attachment_content_type :cover,content_type: /\Aimage\/.*\Z/

  has_many :posts
  #acceptance => :terminos_condiciones, es un valor boleano, de aceptación.
  #Numericality => float, enteros solamente 
  #inclusion{in: ["F","M"]}

  def self.from_omniauth(auth)
  	where(provider: auth['provider'], uid: auth['uid']).first_or_create do |user|
  		if auth[:info]
  			#user.email = auth[:info][:email]
  			user.name = auth[:info][:name]
  		end
  		user.password = Devise.friendly_token[0,20]
  	end
  	
  end

  private
    def validate_username_regex
      unless username =~ /\A[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_]*\z/
        errors.add(:username,"El username debe iniciar con una letra y contener solo letras y números")
      end      
    end
end

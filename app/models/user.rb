# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  include Paginatable
  include NameSearchable

  enum profile: { admin: "admin", normal: "normal"}

  validates :name, presence: true
  validates :profile, presence: true, inclusion: { in: profiles.keys }
end

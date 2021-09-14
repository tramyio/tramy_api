# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_one :profile, dependent: :destroy
  has_one :account, dependent: :destroy

  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_commit :create_then_associate_profile, on: :create
  after_commit :create_then_associate_account, on: :create

  delegate :organization, to: :account

  def create_then_associate_profile
    Profile.create(user: self)
  end

  def create_then_associate_account
    Account.create(user: self, active: false)
  end
end

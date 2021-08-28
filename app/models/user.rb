# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_one :profile
  has_one :account

  after_commit :create_then_associate_profile, on: :create
  after_commit :create_then_associate_account, on: :create

  def create_then_associate_profile
    Profile.create(user: self)
  end

  def create_then_associate_account
    Account.create(user: self)
  end
end

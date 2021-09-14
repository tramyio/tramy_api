# frozen_string_literal: true

class AccountsController < ApplicationController
  # TODO: Handle account invitation by email
  # TODO: Update account params (update organization_id)
  def index
    @accounts = Account.where(organization: current_user.organization)
    render json: AccountSerializer.new(@accounts).serializable_hash[:data]
  end
end
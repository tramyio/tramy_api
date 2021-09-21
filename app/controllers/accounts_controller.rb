# frozen_string_literal: true

class AccountsController < ApplicationController
  # TODO: Handle account invitation by email
  # TODO: Update account params (update organization_id)
  def index
    if current_user.organization.nil?
      return render json: 'This account does not belong to a valid organization',
                    status: :not_found
    end

    @accounts = Account.where(organization: current_user.organization)
    render json: AccountSerializer.new(@accounts).serializable_hash[:data]
  end
end

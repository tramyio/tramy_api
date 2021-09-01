# frozen_string_literal: true

module Hookdeck
  class MessagesController < ApplicationController
    def webhook
      puts params
      head :ok
    end
  end
end

# frozen_string_literal: true

class AnalyticsController < ApplicationController
  include ActionView::Helpers::DateHelper
  before_action :set_organization, only: %i[index]

  def index
    render json: {
      leads_this_week: leads_this_week,
      leads_in_tramy: leads_in_tramy,
      average_time_first_reply: average_time_first_reply
    }
  end

  # Leads this week
  def leads_this_week
    @organization.leads.where(created_at: (DateTime.now.beginning_of_week)..(DateTime.now)).count
  rescue StandardError
    0
  end

  # Leads obtained throughout history
  def leads_in_tramy
    @organization.leads.count
  rescue StandardError
    0
  end

  def average_time_first_reply
    first_reply_time_array = @organization.leads
                                          .where(created_at: (DateTime.now.beginning_of_week)..(DateTime.now))
                                          .map do |lead|
      if lead.chat.first_lead_message && lead.chat.first_agent_message
        lead.chat.first_agent_message['timestamp'].to_i - lead.chat.first_lead_message['timestamp'].to_i
      end
    end.compact
    humanize_time(average(first_reply_time_array)).to_s
  end

  def average(arr = [0])
    arr.sum(0) / arr.size
  rescue StandardError
    0
  end

  def humanize_time(secs)
    [[60, :seconds], [60, :minutes], [24, :hours], [Float::INFINITY, :days]].map do |count, name|
      next unless secs.positive?

      secs, n = secs.divmod(count)

      "#{n.to_i} #{name}" unless n.to_i.zero?
    end.compact.reverse.join(' ')
  end

  private

  def set_organization
    @organization = current_user.organization
  end
end

# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

if Rails.env.development?
  users = [
    { email: 'admin@tramy.io', password: 123_456 },
    { email: 'agent1@tramy.io', password: 123_456 },
    { email: 'agent2@tramy.io', password: 123_456 }
  ]

  leads = [
    { name: 'Jhon Smith', phone: '51900000001' },
    { name: 'Alex Pretell', phone: '51999888777' },
    { name: 'Luisa Rodriguez', phone: '51987654321' }
  ]

  org = Organization.create(name: 'Disoft', phone: '51999666333', provider_api_key: 'aDlgxf_sandbox')

  pipe = Pipeline.create(name: 'Clientes', organization: org)

  stages = [
    { name: 'Nuevo lead' },
    { name: 'Llamada agendada' },
    { name: 'Cotizacion' },
    { name: 'Pagado' }
  ]

  stages.each do |stage|
    Stage.create(name: stage[:name], pipeline: pipe)
  end

  # Seeder
  puts 'Tramy is planting seeds for users'
  users.each do |user|
    User.create(email: user[:email], password: user[:password])
  end

  puts 'Tramy is planting seeds for leads'
  leads.each do |lead|
    Lead.create(name: lead[:name], phone: lead[:phone])
  end

  puts 'Tramy is planting seeds for stages'
  stages
end

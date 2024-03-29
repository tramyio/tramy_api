# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

users = [
  { email: 'admin@tramy.io', password: 123_456 },
  { email: 'agent1@tramy.io', password: 123_456 },
  { email: 'agent2@tramy.io', password: 123_456 }
]

puts 'Tramy is planting seeds for users'
users.each do |user|
  User.create(email: user[:email], password: user[:password])
end

org = Organization.create(name: 'ACME', phone: '4930609859535', provider_api_key: 'aDlgxf_sandbox')

pipe = Pipeline.create(name: 'Clientes', organization: org)

stages = [
  { name: 'Nuevo lead' },
  { name: 'Llamada agendada' },
  { name: 'Cotizacion' },
  { name: 'Pagado' }
]

puts 'Tramy is planting seeds for stages'
stages.each do |stage|
  Stage.create(name: stage[:name], pipeline: pipe)
end

leads = [
  { name: 'Jhon Smith', phone: '51900000001' },
  { name: 'Alex Pretell', phone: '51999888777' },
  { name: 'Luisa Rodriguez', phone: '51987654321' }
]

puts 'Tramy is planting seeds for leads'
leads.each do |lead|
  Lead.create(name: lead[:name], phone: lead[:phone], organization_id: org.id)
end

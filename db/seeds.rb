# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
require 'faker'

CustomOrganisationName.create(name: 'GovWifi Super Administrators')

super_admin_organisation = Organisation.create!(
  name: 'GovWifi Super Administrators', service_email: 'it@gds.com', super_admin: true
)

super_admin_organisation.users.create(
  email: "admin@gov.uk",
  password: "password",
  name: "Steve",
  confirmed_at: Time.zone.now
)

organisation = Organisation.create(
  name: 'UKTI Education', service_email: 'it@parks.com'
)
organisation.users.create(
  email: "test@gov.uk",
  password: "password",
  name: "Steve",
  confirmed_at: Time.zone.now
)

3.times do
  User.create(
    email: Faker::Name.first_name + "@gov.uk",
    password: "password",
    name: Faker::Name.name,
    confirmed_at: Time.zone.now,
    organisation: organisation
  )
end

2.times do
  User.create(
    email: Faker::Name.first_name + "@gov.uk",
    password: "password",
    name: Faker::Name.name,
    confirmed_at: nil,
    organisation: organisation
  )
end

location_one = Location.create!(
  address: 'Momentum Centre, London',
  postcode: 'SE10SX',
  organisation_id: organisation.id
)

location_two = Location.create!(
  address: '136 Southwark Street, London',
  postcode: 'E33EH',
  organisation_id: organisation.id
)

20.times do
  Ip.create!(address: Faker::Internet.unique.public_ip_v4_address, location: location_one)
end

20.times do
  Ip.create!(address: Faker::Internet.unique.public_ip_v4_address, location: location_two)
end

location_two.ips.each_with_index do |ip, index|
  Session.create(
    start: (Time.now - index.day).to_s,
    success: index.even?,
    username: "Garry",
    siteIP: ip.address
  )
end

MouTemplate.create!

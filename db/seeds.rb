# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
require 'faker'

admin_organisation = Organisation.create!(
  name: "Government Digital Service", service_email: 'it@gds.com'
)
admin_user = admin_organisation.users.create(
  email: "admin@gov.uk",
  password: "password",
  name: "Steve",
  super_admin: true,
  confirmed_at: Time.zone.now
)

organisation = Organisation.create(
  name: "UKTI Education", service_email: 'it@parks.com'
)
user = organisation.users.create(
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

location_1 = Location.create!(
  address: 'Momentum Centre, London',
  postcode: 'SE10SX',
  organisation_id: organisation.id
)

location_2 = Location.create!(
  address: '136 Southwark Street, London',
  postcode: 'E33EH',
  organisation_id: organisation.id
)

<<<<<<< HEAD
20.times do
  Ip.create!(address: Faker::Internet.unique.ip_v4_address, location: location_1)
end

20.times do
  Ip.create!(address: Faker::Internet.unique.ip_v4_address, location: location_2)
=======
20.times do |i|
  Ip.create!(address: "141.168.1.#{i}", location: location_1)
end

20.times do |i|
  Ip.create!(address: "141.168.3.#{i}", location: location_2)
>>>>>>> Add docker instance for fake
end

location_2.ips.each_with_index do |ip, index|
  Session.create(start: (Time.now - index.day).to_s,
    success: index.even?,
    username: "Garry",
    siteIP: ip.address
  )
end

MouTemplate.create!

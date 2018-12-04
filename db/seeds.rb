# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
require 'faker'

admin_organisation = Organisation.create(
  name: "Super Admins", service_email: 'it@gds.com'
)
admin_user = admin_organisation.users.create(
  email: "admin@gov.uk",
  password: "password",
  name: "Steve",
  super_admin: true,
  confirmed_at: Time.zone.now
)

organisation = Organisation.create(
  name: "Parks & Recreation Dept", service_email: 'it@parks.com'
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

Session.create(start: (Time.now - 1.day).to_s,
  success: true,
  username: "Garry",
  siteIP: '31.242.140.103'
  )

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

Ip.create(address: '31.242.140.103', location: location_2)

20.times do
  Ip.create!(address: Faker::Internet.ip_v4_address, location: location_1)
end

20.times do
  Ip.create!(address: Faker::Internet.ip_v4_address, location: location_2)
end

5.times do
  Organisation.create(
    name: Faker::Company.name, service_email: 'some-service@email.com'
  )
end

MouTemplate.create!

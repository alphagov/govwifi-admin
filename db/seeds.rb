# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

organisation = Organisation.create(name: "Parks & Recreation Dept")
user = organisation.users.create(email: "test@gov.uk", password: "password", name: "Steve")
user.confirm

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

Ip.create!(address: '127.3.3.1', location: location_1)
Ip.create!(address: '193.1.1.9', location: location_2)

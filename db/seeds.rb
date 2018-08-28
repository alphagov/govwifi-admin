# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

organisation = Organisation.create(name: "Parks & Recreation Dept")
user = organisation.users.create(email: "test@gov.uk", password: "password", name: "Steve")
user.confirm

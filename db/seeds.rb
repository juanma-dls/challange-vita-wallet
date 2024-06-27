# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!([
  { email: 'user1@example.com', balance_usd: 1000.0 },
  { email: 'user2@example.com', balance_usd: 2000.0 },
  { email: 'user3@example.com', balance_usd: 3000.0 }
])
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u = User.create name: 'Dad', email: 'gk.parishphilp@gmail.com', password: '1234', role: :admin
u = User.create name: 'Mom', email: 'parishphilp@gmail.com', password: '1234', role: :admin
u = User.create name: 'Avery', email: 'avery.parishphilp@gmail.com', password: '1234', role: :admin

Allowance.create user: u, amount: 1000

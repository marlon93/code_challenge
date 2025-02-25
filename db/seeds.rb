# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

Product.create([
  {
    name: 'Exotic Meats Crate',
    price: 99.99,
    stock: 10
  },
  {
    name: 'Smash and Grab Gift Card',
    price: 74.99,
    stock: 10
  },
  {
    name: 'Whiskey Appreciation Crate',
    price: 149.99,
    stock: 10
  },
  {
    name: 'Chef Knife Making Kit',
    price: 179.99,
    stock: 10
  },
  {
    name: 'Ammo Can Speaker Kit',
    price: 149.99,
    stock: 10
  },
  {
    name: 'Smooth Face Mini Crate',
    price: 69.99,
    stock: 10
  }
])

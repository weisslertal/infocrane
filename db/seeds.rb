# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

CraneOperation.create!(number: 1, name: 'movement toward the load', operation_type: 'step')
CraneOperation.create!(number: 2, name: 'load rigging', operation_type: 'step')
CraneOperation.create!(number: 3, name: 'movement with the load toward the destination', operation_type: 'step')
CraneOperation.create!(number: 4, name: 'unrigging of the load at the destination', operation_type: 'step')

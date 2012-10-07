# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts '-----------------------------'
puts 'Creating Topics'
puts '-----------------------------'

Topic.create({ title: 'test-1' })
Topic.create({ title: 'test-2' })
Topic.create({ title: 'test-3' })
Topic.create({ title: 'test-4' })
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Rake::Task["Docit:seed:role"].invoke
Rake::Task["Docit:seed:title"].invoke
Rake::Task["Docit:seed:consultation_type"].invoke
Rake::Task["Docit:seed:create_admin_user"].invoke

puts 'Finished seeding'
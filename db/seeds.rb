# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  Discussion.create title: 'Do we or do we not build our new office here?', fid:  5712
  Discussion.create title: 'Relokacja restauracji Przeskok', fid:  5712
  Discussion.create title: 'Ten trawnik wymaga pomocy!', fid:  5727
end

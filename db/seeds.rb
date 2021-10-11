# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#     movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#     Character.create(name: 'Luke', movie: movies.first)

require 'csv'
csv_text = File.read(Rails.root.join('lib','seeds','pokemon.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'UTF-8')

csv.each do |row|
    @seed = Pokemon.new
    @seed.name = row["Name"]
    @seed.type_1 = row["Type 1"]
    @seed.type_2 = row["Type 2"] unless row["Type 2"].nil?
    @seed.total = row["Total"]
    @seed.hp = row["HP"]
    @seed.attack = row["Attack"]
    @seed.defense = row["Defense"]
    @seed.sp_atk = row["Sp. Atk"]
    @seed.sp_def = row["Sp. Def"]
    @seed.speed = row["Speed"]
    @seed.generation = row["Generation"]
    @seed.legendary = row["Legendary"]
    @seed.save!
end

puts "Imported pokemons!"

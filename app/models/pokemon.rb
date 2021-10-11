class Pokemon < ApplicationRecord

    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    validates_presence_of :name
    validates_presence_of :type_1
    validates_presence_of :total
    validates_presence_of :hp
    validates_presence_of :attack
    validates_presence_of :defense
    validates_presence_of :sp_atk
    validates_presence_of :sp_def
    validates_presence_of :speed
    validates_presence_of :generation
    validates_inclusion_of :legendary, in: [true, false]
    validates_uniqueness_of :name

    index_name "pokemons"
    document_type "pokemon"

    settings index: { number_of_shards: 1 } do
        mappings dynamic: false do
            indexes :name, analyzer: 'english'
            indexes :type_1, analyzer: 'english'
            indexes :type_2, analyzer: 'english'
        end
    end
    
    def self.search(query)
        __elasticsearch__.search(query: 
            {
                multi_match: {
                query: query,
                type: "best_fields",
                fields: ['name^2', 'type_1^2', 'type_2']
                }
            }
        )
    end
    

end
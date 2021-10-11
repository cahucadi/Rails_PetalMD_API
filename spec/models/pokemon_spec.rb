require 'rails_helper'

describe 'Pokemons API GET METHODS', type: :request do
    
    it 'return all pokemons paginated' do
        get '/api/v1/pokemons'
        # get paginate data with 20 pokemos per page
        expect(JSON.parse(response.body)['data'].size).to eq(20)
        expect(response).to have_http_status(:ok)
    end

    it 'return all pokemons in specific page' do
        get '/api/v1/pokemons/?page=2'
        # get paginate data with 20 pokemos per page
        expect(JSON.parse(response.body)['data'].size).to eq(20)
        expect(response).to have_http_status(:ok)
    end

    it 'return specific pokemon' do
        get '/api/v1/pokemons/1'
        expect(JSON.parse(response.body)['data']['id']).should_not be_nil 
        expect(response).to have_http_status(:ok)
    end

    it 'return non existent pokemon' do
        get '/api/v1/pokemons/-1'
        expect(response).to have_http_status(:not_found)
    end

    it 'return non valid pokemon id' do
        get '/api/v1/pokemons/wrong'
        expect(response).to have_http_status(:not_found)
    end

    it 'return elastic search query' do
        get '/api/v1/pokemons/search/fire'
        expect(JSON.parse(response.body)['data']).should_not be_nil
        expect(response).to have_http_status(:ok)
    end

end

describe 'Pokemons API POST PUT METHODS', type: :request do

    it 'create pokemon successful' do
        post '/api/v1/pokemons', params: {

            pokemon: {
                name: 'Mewtwo ultra' , 
                type_1: 'Psychic' , 
                type_2: 'Ghost' , 
                total: '800' , 
                hp: '120' , 
                attack: '110' , 
                defense: '110' , 
                sp_atk: '180' , 
                sp_def: '160' , 
                speed: '150' , 
                generation: '2' , 
                legendary: 'true'
                }
            }

        # response should have HTTP Status 201 Created
        expect(response).to have_http_status(:created)
    end


    it 'create pokemon same name' do
        post '/api/v1/pokemons', params: {

            pokemon: {
                name: 'Mewtwo repeated' , 
                type_1: 'Psychic' , 
                type_2: 'Ghost' , 
                total: '800' , 
                hp: '120' , 
                attack: '110' , 
                defense: '110' , 
                sp_atk: '180' , 
                sp_def: '160' , 
                speed: '150' , 
                generation: '2' , 
                legendary: 'true'
                }
            }
        # response should have HTTP Status 201 Created
        expect(response).to have_http_status(:created)

        post '/api/v1/pokemons', params: {

            pokemon: {
                name: 'Mewtwo repeated' , 
                type_1: 'Psychic' , 
                type_2: 'Ghost' , 
                total: '800' , 
                hp: '120' , 
                attack: '110' , 
                defense: '110' , 
                sp_atk: '180' , 
                sp_def: '160' , 
                speed: '150' , 
                generation: '2' , 
                legendary: 'true'
                }
            }

            expect(response).to have_http_status(:bad_request).or have_http_status(:unprocessable_entity) 

    end    

    it 'create with invalid or missing pokemon attributes' do
        post '/api/v1/pokemons', params: {
            pokemon: {
                name: '',
                type_1: 'Wrong',
                total: 'MAX'
            }
        }

        expect(response).to have_http_status(:bad_request).or have_http_status(:unprocessable_entity) 
    
    end

    it 'update pokemon successful' do

        post '/api/v1/pokemons', params: {
            pokemon: {
                name: 'Powerful Pokemon' , 
                type_1: 'Psychic' , 
                type_2: 'Ghost' , 
                total: '800' , 
                hp: '120' , 
                attack: '110' , 
                defense: '110' , 
                sp_atk: '180' , 
                sp_def: '160' , 
                speed: '150' , 
                generation: '2' , 
                legendary: 'true'
                }
            }

        id = JSON.parse(response.body)['data']['id']

        put "/api/v1/pokemons/#{id}", params: {
            pokemon: {
                name: 'mewtwo supra' , 
                type_1: 'Psychic' , 
                type_2: 'Ghost' , 
                total: '800' , 
                hp: '120' , 
                attack: '110' , 
                defense: '110' , 
                sp_atk: '180' , 
                sp_def: '160' , 
                speed: '150' , 
                generation: '2' , 
                legendary: 'true'
                }
            }

        # response should have HTTP Status 200 ok
        expect(response).to have_http_status(:ok)
        
    end

    it 'update with invalid or missing pokemon attributes' do
        put '/api/v1/pokemons/1', params: {

            pokemon: {
                name: '' , 
                type_1: 'Psychic' , 
                type_2: 'Ghost' ,
                }
            }

        expect(response).to have_http_status(:bad_request).or have_http_status(:unprocessable_entity) 
        
    end

end


describe 'Pokemons API DELETE METHOD', type: :request do

    it 'delete pokemon' do

        post '/api/v1/pokemons', params: {
            pokemon: {
                name: 'Mewtwo ultra' , 
                type_1: 'Psychic' , 
                type_2: 'Ghost' , 
                total: '800' , 
                hp: '120' , 
                attack: '110' , 
                defense: '110' , 
                sp_atk: '180' , 
                sp_def: '160' , 
                speed: '150' , 
                generation: '2' , 
                legendary: 'true'
                }
            }

        id = JSON.parse(response.body)['data']['id']

        delete "/api/v1/pokemons/#{id}"
        expect(response).to have_http_status(:no_content).or  have_http_status(:not_found)      
    
    end

end
module Api
    module V1
        class PokemonsController < ApplicationController
            
            include Pagy::Backend

            # Route actions
            before_action :set_pokemon, only: [:show, :update, :destroy]
            after_action { pagy_headers_merge(@pagy) if @pagy }
            after_action :remove_pagination_cache, only: [:create, :update, :destroy]

            def index

                page = 1
                if !params[:page].blank?
                    page = params[:page]
                    
                    if page.to_i<1
                        page = 1
                    end
                end

                if $redis.exists?("pokemons-page#{page}")==false
                    @pagy, @pokemons = pagy(Pokemon.all, page: page, items: 20, overflow: :last_page)
                    @pokemon_serialized = PokemonSerializer.new(@pokemons).serializable_hash.to_json
                    $redis.set("pokemons-page#{@pagy.page}", @pokemon_serialized)
                    $redis.expire("pokemons-page#{@pagy.page}",1.hour.to_i)
                    render json: @pokemon_serialized, status: :ok
                else
                    @pokemons_cached = $redis.get("pokemons-page#{page}")
                    render json: @pokemons_cached, status: :ok
                end

            end

            def show
                @pokemon_serialized = PokemonSerializer.new(@pokemon).serializable_hash.to_json
                if @pokemon
                    render json: @pokemon_serialized, status: :ok
                else
                    render json: { data: @pokemon.errors }, status: :not_found
                end
            end

            def create
                @pokemon = Pokemon.new(pokemon_params)
                if @pokemon.save
                    render json: PokemonSerializer.new(@pokemon).serializable_hash.to_json, status: :created
                else
                    render json: { data: @pokemon.errors }, status: :unprocessable_entity
                end
                
            end

            def update
                if @pokemon.update(pokemon_params)
                    render json: PokemonSerializer.new(@pokemon).serializable_hash.to_json, status: :ok
                else
                    render json: { data: @pokemon.errors }, status: :unprocessable_entity
                end
            end

            def destroy
                @pokemon.destroy
            end

            def search
                unless params[:query].blank?
                    @elastic_results = Pokemon.search( params[:query] ).results
                    @elastic_serialized = PokemonSerializer.new(@elastic_results).serializable_hash.to_json
                    render json: @elastic_serialized, status: :ok
                end
            end
            

            private

            def set_pokemon
                @pokemon = Pokemon.find(params[:id])
            end

            def pokemon_params
                params.require(:pokemon).permit(:page, :name, :type_1, :type_2, :total, :hp, :attack, :defense, :sp_atk, :sp_def, :speed, :generation, :legendary)
            end

            def remove_pagination_cache
                keys = $redis.keys("pokemons-page*")
                $redis.del(keys) unless keys.empty?
            end

        end
    end
end
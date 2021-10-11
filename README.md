# README

<p style="text-align:justify">
This project is a technical test request from the company **PetalMD**. After analyzing the tech stack used by PetalMD and the information given in the job description, I decided to create an Restful API using <b>Rails, MySQL, ElasticSearch, Redis and Docker</b>. For testing I write unit tests using <b>Rspec</b> and <b>Postman</b> for response analysis.
<br/><br/>
Using the CSV file with and extensive list of Pokémons ( available <a href="https://gist.github.com/armgilles/194bcff35001e7eb53a2a8b441e8b2c6" target="_blank"> here </a> ), I create a <b>MySQL</b> database and expose an API with CRUD ( Create, Read, Update, Delete ) actions, and an extra Search action using <b>ElasticSearch</b>. 
<br/><br/>
For pagination I used <b>Pagy</b> ( A ruby gem with outstanding performance. Detailed benchmark report <a href="https://ddnexus.github.io/pagination-comparison/gems.html" target="_blank"> here </a> ) and <b>Redis</b> for pagination caching, which significantly improved response time. Finally, I decided to use <b>JSON:API</b> specification for building APIS in JSON ( https://jsonapi.org/ ), this shared conventions for how a client should request resources and how a server should respond to those requests (for example <b>data:</b> for primary content used in this project)   

</p>

#
## Languages and Tools used
<p align="center"> 
<a href="https://rubyonrails.org" target="_blank"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/rails/rails-original-wordmark.svg" alt="rails" width="30" /> </a>   &nbsp;&nbsp;   <a href="https://www.mysql.com/" target="_blank"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/mysql/mysql-original-wordmark.svg" alt="mysql" width="30" /> </a> &nbsp;&nbsp;  <a href="https://www.elastic.co" target="_blank"> <img src="https://www.vectorlogo.zone/logos/elastic/elastic-icon.svg" alt="elasticsearch" width="30" /> </a> &nbsp;&nbsp;  <a href="https://redis.io" target="_blank"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/redis/redis-original-wordmark.svg" alt="redis" width="30" /> </a>  
&nbsp; &nbsp; &nbsp; <b style="font-size:18px;">plus</b>  &nbsp; &nbsp; &nbsp;
<a href="https://www.docker.com/" target="_blank"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/docker/docker-original-wordmark.svg" alt="docker" width="30" /> </a>  &nbsp;&nbsp;   <a href="https://git-scm.com/" target="_blank"> <img src="https://www.vectorlogo.zone/logos/git-scm/git-scm-icon.svg" alt="git" width="30" /> </a>  &nbsp;&nbsp;    <a href="https://postman.com" target="_blank"> <img src="https://www.vectorlogo.zone/logos/getpostman/getpostman-icon.svg" alt="postman" width="30" /> </a>
</p>


#
## System dependencies

This project uses **Docker** containers for environment configuration and automatization.

* Containers used: **Ruby** 2.5.3 , **Rails** 5.2.6 , **Mysql** 5.7 , **Redis** 5.0.14 , **Elasticsearch** 7.3.0

#
## Configuration

- Clone or download this repository 

* Install/Open Docker

* Build and start all services required (see **docker-compose.yml** and **Dockerfile** for configuration)

    ```bash
    docker-compose up -d --build
    ```
* Populate the MySQL database using the downloaded CSV data (**/lib/seeds/pokemon.csv**)

    ```bash
    docker-compose run app rake db:migrate:reset

    docker-compose run app rails db:seed
    ```
* This imported records will populate the ElasticSearch instance automatically.

* The project now is ready for use with Postman, no additional configuration required.

* For unit testing using rspec

    ```bash
    docker-compose run app rspec
    ```
#
## Usage

* This API expose the following routes using rails **resources** 

    ```ruby
      get 'pokemons/search/*query' => 'pokemons#search'
      resources :pokemons , only: [:index, :show, :create, :update , :destroy]
    ```

* The base URL for the project is: http://localhost:3000/api/v1/pokemons

    <table>
        <thead>
            <tr>
            <th>HTTP Verb</th>
            <th>Path</th>
            <th>Controller#Action</th>
            <th>Used for</th>
            </tr>
            </thead>
        <tbody>
            <tr>
                <td>GET</td>
                <td>/pokemons</td>
                <td>pokemons#index</td>
                <td>display a list of all pokemons (paginated and cached using Redis)</td>
            </tr>
            <tr>
                <td>GET</td>
                <td>/pokemons?page=4</td>
                <td>pokemons#index</td>
                <td>display a list of all pokemons at n page</td>
            </tr>
            <tr>
                <td>GET</td>
                <td>/pokemons/search/:query</td>
                <td>pokemons#search</td>
                <td>Search all pokemons by name and type using Elasticsearch</td>
            </tr>
            <tr>
                <td>POST</td>
                <td>/pokemons</td>
                <td>pokemons#create</td>
                <td>create a new pokémon</td>
            </tr>
            <tr>
                <td>GET</td>
                <td>/pokemons/:id</td>
                <td>pokemons#show</td>
                <td>display a specific pokémon</td>
            </tr>
            <tr>
                <td>PATCH/PUT</td>
                <td>/pokemons/:id</td>
                <td>pokemons#update</td>
                <td>update a specific pokémon</td>
            </tr>
            <tr>
                <td>DELETE</td>
                <td>/pokemon/:id</td>
                <td>pokemon#destroy</td>
                <td>delete a specific pokémon</td>
            </tr>
        </tbody>
    </table>

## License
[MIT](https://choosealicense.com/licenses/mit/)

<br/>

***Demo deploy on AWS is under construction***
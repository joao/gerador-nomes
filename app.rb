# encoding: utf-8

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# enable direct JSON requests
# https://stackoverflow.com/questions/33246470/sinatra-app-on-heroku-responds-with-forbidden-if-i-follow-links
set :protection, :except => [:json_csrf]

require 'sinatra'
require 'sinatra/reloader'
require "sinatra/multi_route"
require "csv"
require "json"

# Nomes e Apelidos
nomes = Array.new
apelidos = Array.new

File.read("data/nomes.csv").each_line do |line|
  nomes << line.strip
end

File.read("data/apelidos.csv").each_line do |line|
  apelidos << line.strip
end


# Homepage
get '/' do
  @nomes_count = nomes.count
  @apelidos_count = apelidos.count
  @nome1 = nomes.sample
  @apelido1 = apelidos.sample
  @apelido2 = apelidos.sample
  erb :index
end


# API
get '/nome/aleatorio' do
  content_type :json
  @nome1 = nomes.sample
  @apelido1 = apelidos.sample
  @apelido2 = apelidos.sample
  [@nome1, @apelido1, @apelido2].to_json
end

get '/nome' do
  content_type :json
  nomes.sample
end

get '/nomes', '/nomes/:number' do
  content_type :json
  params['number'] ? number = params['number'].to_i : number = 10
  nomes.shuffle[0,number].to_json
end


get '/apelido' do
  content_type :json
  apelidos.sample
end

get '/apelidos', '/apelidos/:number' do
  content_type :json
  params['number'] ? number = params['number'].to_i : number = 10
  apelidos.shuffle[0,number].to_json
end



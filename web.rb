# coding: utf-8
require 'sinatra/base'
require 'erb'
require './gmail_client'

#require 'padrino-core'

class Web < Sinatra::Base
  include ERB::Util
  enable :sessions
#  disable :logging

#  use Padrino::Logger::Rack, '/'

  get '/' do
    if ! session["address"] and ! session["password"]
      redirect '/login'
    end

    client = GmailClient.new(session["address"], session["password"])
    @mails = client.list_new_mail
    erb :index
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    session["address"]  = params[:address]
    session["password"] = params[:password]
    redirect '/'
  end
end



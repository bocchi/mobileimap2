# coding: utf-8
require 'sinatra/base'
require 'erb'
require './gmail_client'

class Web < Sinatra::Base
  include ERB::Util

  use Rack::Session::Cookie

  get '/' do
    if ! session["address"] or ! session["password"]
      redirect '/login'
    end

    client = GmailClient.new(session["address"], session["password"])
    @mails = client.list_new_mail
    session["login"] = 1
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

  post '/logout' do
    if ! session["login"]
      redirect '/login'
    end

    session["login"]    = nil
    session["address"]  = nil
    session["password"] = nil
    redirect '/login'
  end
end



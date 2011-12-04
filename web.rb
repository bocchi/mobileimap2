# coding: utf-8
require 'sinatra/base'
require 'erb'
require './gmail_client'

class Web < Sinatra::Base
  include ERB::Util
  get '/' do
    client = GmailClient.new
    @mails = client.list_new_mail
    erb :index
  end

  get '/todo' do
    @todo = [
      'css',
      'おーとぺーじゃー',
      '表示させたら既読にする',
      '未読にする',
      'layout',
    ]
    erb :todo
  end
end



# coding: utf-8
require 'net/imap'
require 'kconv'
require 'pit'
require 'pp'

class GmailClient
  def initialize
    config = Pit.get(
      'yagc',
      :requre => {
        'address' => 'your gmail address',
        'pass'    => 'your gmail password'
      }
    );

    @imap = Net::IMAP.new(
      'imap.gmail.com',
      :port => 993,
      :ssl  => {
        :verify_mode => OpenSSL::SSL::VERIFY_NONE
      }
    )

    @imap.login(config['address'], config['pass'])
    @imap.select('INBOX')
  end

  def list_new_mail
    content = ''
    mails = []
    @imap.search(['UNSEEN']).each_with_index do |message_id, i|
      fetch_data = @imap.fetch(message_id, ['ENVELOPE', 'BODY.PEEK[TEXT]'])[0]
      envelope = fetch_data.attr['ENVELOPE']
      data = {
        'message_id' => message_id,
        'subject'    => envelope.subject ? envelope.subject.toutf8 : 'no subject',
        'body'       => fetch_data.attr['BODY[TEXT]'].toutf8,
      }
      mails.push data
    end
    return mails
  end
end


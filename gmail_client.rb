require 'digest/sha1'
require 'gmail'
require 'kconv'
require 'pp'

class GmailClient
  @@gmails = {}

  def initialize(address, password)
    # XXX: あまりいけてないけど、ログインが遅いっぽいのでインスタンスキャッシュしている
    digested = Digest::SHA1.hexdigest(address + '::' + password)
    if @@gmails[digested]
      @gmail = @@gmails[digested]
    else
      @gmail = Gmail.new(address, password)
      @@gmails[digested] = @gmail
    end
  end

  def list_new_mail
    @gmail.inbox.mails(:unseen).map do |mail|
      body =''
      if mail.multipart?
        mail.parts.each do |part|
          body = part.decoded.toutf8 if /^text\/plain;/ =~ part.content_type
        end
      else
        body = mail.body.decoded.toutf8
      end

      # XXX: 既読フラグを落とす
      mail.mark(:unread)
      {
        :message_id => mail.message_id,
        :subject    => mail.subject ? mail.subject.toutf8 : 'no subject',
        :body       => body,
      }
    end
  end
end



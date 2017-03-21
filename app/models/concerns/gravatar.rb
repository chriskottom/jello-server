module Gravatar
  extend ActiveSupport::Concern

  def gravatar_url
    if self.email
      gravatar_hash = Digest::MD5::hexdigest(self.email).downcase
      "http://gravatar.com/avatar/#{ gravatar_hash }.png"
    else
      nil
    end
  end
end

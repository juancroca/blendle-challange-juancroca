class User < ActiveRecord::Base
  has_secure_password
  before_create :set_access_token

  validates :email, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/}, uniqueness: true

  def set_access_token
    unless self.access_token
      self.access_token = SecureRandom.uuid
      self.save unless self.new_record?
    end
  end

  def destroy_token
    self.update_attribute(:access_token, nil)
  end
end
module HAL
  class UserRepresenter < Roar::Decorator
    include Roar::JSON::HAL

    property :id
    property :email
    property :access_token
    property :created_at
    property :updated_at

    link :lists do
      "/lists"
    end

    link :tags do
      "/tags"
    end

    link :items do
      "/items"
    end
    
  end
end

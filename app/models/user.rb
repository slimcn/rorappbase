class User < ActiveRecord::Base
  has_many :employes_users, :dependent => :destroy
  # has_many :employes, :through => :employes_users
  belongs_to :employe
end

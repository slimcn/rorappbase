class Role < ActiveRecord::Base
  has_many :roles_users, :dependent => :destroy
  has_many :users, :through => :roles_users

  has_many :operations_roles, :dependent => :destroy
  has_many :operations, :through => :operations_roles
end

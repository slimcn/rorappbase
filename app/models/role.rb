class Role < ActiveRecord::Base
  has_many :operations_roles, :dependent => :destroy
  has_many :operations, :through => :operations_roles
  # has_many_with_attributes :operations_roles, :dependent => :destroy

  has_many :roles_users, :dependent => :destroy
  has_many :users, :through => :roles_users
  # has_many_with_attributes :roles_users, :dependent => :destroy

end

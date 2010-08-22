class Operation < ActiveRecord::Base
  acts_as_tree
  has_many :operations_roles, :dependent => :destroy
  has_many :roles, :through => :operations_roles
end

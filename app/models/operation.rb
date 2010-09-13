class Operation < ActiveRecord::Base
  has_many :operations_roles, :dependent => :destroy
  has_many :roles, :through => :operations_roles
  has_many_with_attributes :operations_roles, :dependent => :destroy

  acts_as_tree :order => "id"
end

class Department < ActiveRecord::Base
  acts_as_tree
  has_many :employes, :dependent => :destroy
  has_many :departmentmanagers, :dependent => :destroy
  has_many :managers, :through => :departmentmanagers, :source => :employe
end

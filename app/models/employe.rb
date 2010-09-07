class Employe < ActiveRecord::Base
  belongs_to :department
  has_many :departmentmanagers, :dependent => :destroy
  has_many :manageddepartments, :through => :departmentmanagers, :source => :department
  has_many :employes_users, :dependent => :destroy
  # has_many :users, :through => :employes_users
  has_many :users, :dependent => :destroy

  has_many :rordemos, :dependent => :destroy

  has_many :formlogs, :dependent => :destroy
  has_many_with_attributes :formlogs, :dependent => :destroy
end

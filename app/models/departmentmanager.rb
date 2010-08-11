class Departmentmanager < ActiveRecord::Base
  belongs_to :department
  belongs_to :employe
end

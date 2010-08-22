class OperationsRole < ActiveRecord::Base
  belongs_to :operation
  belongs_to :role
end

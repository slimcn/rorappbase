class Flownode < ActiveRecord::Base
  has_many :auditflows_flownodes, :dependent => :destroy
  has_many_with_attributes :auditflows_flownodes, :dependent => :destroy
end

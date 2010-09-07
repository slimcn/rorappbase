class Auditflow < ActiveRecord::Base
  has_many :auditflows_flownodes, :dependent => :destroy
  has_many_with_attributes :auditflows_flownodes, :dependent => :destroy

  has_many :auditflows_forms, :dependent => :destroy
  has_many_with_attributes :auditflows_forms, :dependent => :destroy
end

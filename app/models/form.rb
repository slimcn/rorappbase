class Form < ActiveRecord::Base
  has_many :forms_menutrees, :dependent => :destroy
  has_many :menutrees, :through => :forms_menutrees
  has_many_with_attributes :forms_menutrees, :dependent => :destroy

  has_many :fields, :dependent => :destroy
  has_many_with_attributes :fields, :dependent => :destroy

  has_many :auditflows_forms, :dependent => :destroy
  has_many_with_attributes :auditflows_forms, :dependent => :destroy

  has_many :formlogs, :dependent => :destroy
  has_many_with_attributes :formlogs, :dependent => :destroy
end

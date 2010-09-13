class Menutree < ActiveRecord::Base
  acts_as_tree :order => "code"
  has_many :forms_menutrees, :dependent => :destroy
  has_many :forms, :through => :forms_menutrees
  has_many_with_attributes :forms_menutrees, :dependent => :destroy
end

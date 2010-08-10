class Menutree < ActiveRecord::Base
  acts_as_tree
  has_many :forms_menutrees, :dependent => :destroy
  has_many :forms, :through => :forms_menutrees
end

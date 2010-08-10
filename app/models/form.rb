class Form < ActiveRecord::Base
  has_many :forms_menutrees, :dependent => :destroy
  has_many :menutrees, :through => :forms_menutrees
end

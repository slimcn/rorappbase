class FormsMenutree < ActiveRecord::Base
  belongs_to :menutree
  belongs_to :form
end

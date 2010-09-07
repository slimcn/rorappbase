class Formlog < ActiveRecord::Base
  belongs_to :form
  belongs_to :auditflows_flownode
  belongs_to :employe
  belongs_to :user
  belongs_to :before_sequence, :class_name => :auditflows_flownode, :foreign_key => :before_sequence_id
  belongs_to :after_sequence, :class_name => :auditflows_flownode, :foreign_key => :after_sequence_id
end

class AuditflowsForm < ActiveRecord::Base
  belongs_to :auditflow
  belongs_to :form
  belongs_to :auditflows_flownode
end

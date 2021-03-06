class AuditflowsFlownode < ActiveRecord::Base
  belongs_to :auditflow
  belongs_to :flownode
  has_many :auditflows_forms, :dependent => :destroy
  has_many_with_attributes :auditflows_forms, :dependent => :destroy
  belongs_to :role
  has_many :formlogs, :dependent => :destroy
  has_many_with_attributes :formlogs, :dependent => :destroy

  def self.next_flownode(node)
    str_conditions = "auditflow_id=" + node.auditflow_id.to_s + " and sequence>'" + node.sequence.to_s + "'"
    next_node = AuditflowsFlownode.find(:first, :conditions => str_conditions, :order => "sequence")
    return next_node
  end

  def self.pre_flownode(node)
    str_conditions = "auditflow_id=" + node.auditflow_id.to_s + " and sequence<'" + node.sequence.to_s + "'"
    pre_node = AuditflowsFlownode.find(:first, :conditions => str_conditions, :order => "sequence desc")
    return pre_node
  end
end

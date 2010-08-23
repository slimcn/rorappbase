# -*- coding: utf-8 -*-
class Rordemo < ActiveRecord::Base
  belongs_to :code_rule
  belongs_to :employe
  belongs_to :department
  validates_uniqueness_of :code

  before_validation_on_create :get_new_unique_code

  protected
  def get_new_unique_code
    field_name = CodeRule.find_by_id(self.code_rule_id)[:field_name]
    if CodeRule.code_rules_to_check_code_equal(Rordemo, field_name, self.code, self.id)
      @code, @code_pre, @code_max_seq, @code_rule_id = CodeRule.code_rules_to_get_unique_code(Rordemo, self.code, self.id)
      self.code = @code # 获得最新不重复编码
      self.code_rule.seq = @code_max_seq # 获得最新编码对应的编码规则序号
    end
  end
end

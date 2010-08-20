# -*- coding: utf-8 -*-
class CodeRule < ActiveRecord::Base
  has_many :rordemos

  # 根据编码规则表数据获得新编码
  def self.code_rules_to_get_code(table_name, type="")
    rec_rule = CodeRule.find(:first, :conditions => "table_name='"+table_name+"'")
    if not rec_rule #编码规则不存在
      logger.info("table_name='" + table_name + "'的编码规则不存在！")
      return [nil, nil, nil, nil] if not rec_rule # 若编码规则不存在，则返回nil
    end
    title = rec_rule[:title]
    seq = rec_rule[:seq]
    seq_len = rec_rule[:seq_len]
    step = rec_rule[:step]

    code_pre = title
    # 将title按[]逐个进行转义替换
    t = Time.now
    year = t.year.to_s
    month = t.month.to_s
    day = t.day.to_s
    code_pre.sub!("[YY]",     year[-2,2])
    code_pre.sub!("[YYYY]",   year[-4,4])
    code_pre.sub!("[MM]",     "0"*(2-month.length)+month)
    code_pre.sub!("[DD]",     "0"*(2-day.length)+day)
    employe_code = User.current_user.employe.code # 人员编码
    employe_code = 'xxxx' if employe_code.blank?
    department_code = User.current_user.employe.department.code # 部门编码
    department_code = 'xxxx' if department_code.blank?
    code_pre.sub!("[E]",     employe_code[-2,2]) # 人员编码1位
    code_pre.sub!("[EE]",     employe_code[-2,2]) # 人员编码2位
    code_pre.sub!("[EEE]",     employe_code[-3,3]) # 人员编码3位
    code_pre.sub!("[EEEE]",   employe_code[-4,4]) # 人员编码4位
    code_pre.sub!("[P]",     department_code[-2,2]) # 部门编码1位
    code_pre.sub!("[PP]",     department_code[-2,2]) # 部门编码2位
    code_pre.sub!("[PPP]",     department_code[-3,3]) # 部门编码3位
    code_pre.sub!("[PPPP]",     department_code[-4,4]) # 部门编码4位
    # todo: 有多少种替换？保存时更新序号？保存前重号的检查和处理？

    code_seq = seq + step # 新序号 = 序号 + 步长
    code = code_pre + "0"*(seq_len-code_seq.to_s.length) + code_seq.to_s
    return [code, code_pre, code_seq, rec_rule[:id]]
  end

  # 获得最终不重复的编码
  # def code_rules_to_get_unique_code(obj, field_name, code, rec_id, rule_id, old_seq, code_pre) # 无法传递后三个参数，故直接重新获取
  def self.code_rules_to_get_unique_code(obj, code, rec_id)
    code, code_pre, code_seq, rule_id = code_rules_to_get_code(obj.table_name)
    field_name = CodeRule.find_by_id(rule_id)[:field_name]
    a = 0
    while code_rules_to_check_code_equal(obj, field_name, code, rec_id)
      a += 1
      code, code_pre, code_seq, rule_id = code_rules_to_get_new_code(rule_id, code_seq, code_pre)
    end
    return [code, code_pre, code_seq, rule_id]
  end

  # 检查编码是否重复
  def self.code_rules_to_check_code_equal(obj, field_name, code, rec_id)
    if rec_id and rec_id > 0
      records = obj.find(:all, :conditions => field_name+" = '"+code+"' and id <> "+rec_id)
    else
      records = obj.find(:all, :conditions => field_name+" = '"+code+"'")
    end
    return records.length>0
  end

  # 获得新编码
  def self.code_rules_to_get_new_code(rule_id, old_seq, code_pre)
    rec_rule = CodeRule.find_by_id(rule_id)
    old_seq = rec_rule[:seq] if rec_rule[:seq] > old_seq # 如果原序号比编码规则中基础序号小，则以编码规则中的序号为基础获得新序号
    code_seq = old_seq + rec_rule[:step]
    code = code_pre + "0"*(rec_rule[:seq_len]-code_seq.to_s.length) + code_seq.to_s
    return [code, code_pre, code_seq, rule_id]
  end
end

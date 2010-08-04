# -*- coding: utf-8 -*-
class CodeRule < ActiveRecord::Base
  has_many :rordemos

  # ���ݱ����������ݻ���±���
  def self.code_rules_to_get_code(table_name, type="")
    rec_rule = CodeRule.find(:first, :conditions => "table_name='"+table_name+"'")
    if not rec_rule #������򲻴���
      logger.info("table_name='" + table_name + "'�ı�����򲻴��ڣ�")
      return [nil, nil, nil, nil] if not rec_rule # ��������򲻴��ڣ��򷵻�nil
    end
    title = rec_rule[:title]
    seq = rec_rule[:seq]
    seq_len = rec_rule[:seq_len]
    step = rec_rule[:step]

    code_pre = title
    # ��title��[]�������ת���滻
    t = Time.now
    year = t.year.to_s
    month = t.month.to_s
    day = t.day.to_s
    code_pre.sub!("[YY]",     year[-2,2])
    code_pre.sub!("[YYYY]",   year[-4,4])
    code_pre.sub!("[MM]",     "0"*(2-month.length)+month)
    code_pre.sub!("[DD]",     "0"*(2-day.length)+day)
    employe_code = 'aryb' # ��Ա����
    department_code = 'cbmd' # ���ű���
    code_pre.sub!("[EE]",     employe_code[-2,2]) # ��Ա����2λ
    code_pre.sub!("[EEE]",     employe_code[-3,3]) # ��Ա����3λ
    code_pre.sub!("[EEEE]",   employe_code[-4,4]) # ��Ա����4λ
    code_pre.sub!("[PP]",     department_code[-2,2]) # ���ű���2λ
    code_pre.sub!("[PPP]",     department_code[-3,3]) # ���ű���3λ
    code_pre.sub!("[PPPP]",     department_code[-4,4]) # ���ű���4λ
    # todo: �ж������滻������ʱ������ţ�����ǰ�غŵļ��ʹ���

    code_seq = seq + step # ����� = ��� + ����
    code = code_pre + "0"*(seq_len-code_seq.to_s.length) + code_seq.to_s
    return [code, code_pre, code_seq, rec_rule[:id]]
  end

  # ������ղ��ظ��ı���
  # def code_rules_to_get_unique_code(obj, field_name, code, rec_id, rule_id, old_seq, code_pre) # �޷����ݺ�������������ֱ�����»�ȡ
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

  # �������Ƿ��ظ�
  def self.code_rules_to_check_code_equal(obj, field_name, code, rec_id)
    if rec_id
      records = obj.find(:all, :conditions => field_name+" = '"+code+"' and id <> "+rec_id)
    else
      records = obj.find(:all, :conditions => field_name+" = '"+code+"'")
    end
    return records.length>0
  end

  # ����±���
  def self.code_rules_to_get_new_code(rule_id, old_seq, code_pre)
    rec_rule = CodeRule.find_by_id(rule_id)
    old_seq = rec_rule[:seq] if rec_rule[:seq] > old_seq # ���ԭ��űȱ�������л������С�����Ա�������е����Ϊ������������
    code_seq = old_seq + rec_rule[:step]
    code = code_pre + "0"*(rec_rule[:seq_len]-code_seq.to_s.length) + code_seq.to_s
    return [code, code_pre, code_seq, rule_id]
  end
end

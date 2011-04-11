# -*- coding: utf-8 -*-
# common functions in LimCommon  通用方法定义
module LimCommon

  # 清理hash
  #   hash_param: 待处理的hash
  #   hash_key: hash键列表
  #   clear_blank: 是否清理空值
  def LimCommon.clear_hash hash_param, hash_key=[], clean_blank = true
    hash_param.delete_if { |k, v| (!(hash_key.blank? || hash_key.member?(k))) || (clean_blank && v.blank?) }
  end

  # 哈希转换为字符串
  def LimCommon.hash_to_str hash_param, join_char="&", join_char_key_value="=", filter_blank=true
    join_char = "" unless join_char
    join_char_key_value = "" unless join_char_key_value
    res = ""
    hash_param.each do |key, value|
      tmp_str = (value.blank? ? "" : (key.to_s+join_char_key_value+value.to_s)) unless (value.blank? && filter_blank)
      res += (res.blank? ? "" : join_char) + tmp_str unless tmp_str.blank?
    end
    return res
  end

  # 转换编码，由utf8转为gbk
  def LimCommon.utf82gbk html
    conv = Iconv.new("GBK", "utf-8")
    result = conv.iconv(html)
    result << conv.iconv(nil)
    conv.close
    return result
  end

  # 转换编码，由gbk转为utf8
  def LimCommon.gbk2utf8 html
    conv = Iconv.new("utf-8", "GBK")
    result = conv.iconv(html)
    result << conv.iconv(nil)
    conv.close
    return result
  end

  # 截取字符串
  #   length:输出字段长度（包含省略符）；若无length参数，则不截取
  def LimCommon.truncate_cn(text, length=nil, t_string = '...')
    require 'jcode'
    text = text.to_s
    length ||= text.jlength
    ret = ''

    return text if text.jlength <= length # 若不需截取，则直接返回

    char_length = (t_string.blank? ? length : length-1)
    count = 0
    text.scan(/./u).each do |c|
      ret << c
      # TODO: 对英文大小写字宽的处理尚不完善
      count += (c.length == 1 ? 0.5 : 1)
      if count >= char_length
        ret << t_string
        break
      end
    end
    ret
  end

end

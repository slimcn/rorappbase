# -*- coding: utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def buttonhtml(buttons)
    html = ""
    @sheet_options = { } if not @sheet_options.is_a?(Hash)
    @sheet_options = { "edit_form_type" => "jqgrid_form" }.merge(@sheet_options)
    edit_form_type = @sheet_options.has_key?("edit_form_type") ? @sheet_options["edit_form_type"] : "jqgrid_form"
    buttons.each do |btn|
      html += "<button id='btn_" + btn[0] +"' class='rest-button #{edit_form_type}' pre_url='/#{controller_name}' >" + btn[1] + "</button>"
    end
    return html
  end

  def fields_table_head(sheet, fields)
    html = ""
    fields.each do |field|
      html += "<th width=100>#{I18n.t(('activerecord.attributes.'+sheet['name']+'.'+field[:field]).downcase)}</th>"
    end
    html += "<th> </th>"
    return html
  end

  def fields_table_data(record, fields)
    html = ""
    fields.each do |field|
      html += "<td>#{h(eval('record.'+field[:field]))}</td>"
    end
    return html
  end

  # 生成table格式的form，可定义列数，每字段占两列(标题一列内容一列)
  # <table>
  #   <tr><th></th><tr>
  # </table>
  def fields_table_form(f, fields, column_count=1, column_width = 300, action = nil) # 记录，字段列表，列数
  #def fields_table_form(f, fields, *args) # 记录，字段列表，列数
  #  args.merge(:column_count => 1) if args.has_key?(:column_count)
  #  args.merge(:column_width => 300) if args.has_key?(:column_width)
  #  args.merge(:editable => false) if args.has_key?(:editable)

    html = ""

    # 确定每行字段
    row_fields = fields.in_groups_of(column_count)
    # 逐行逐个字段生成html
    #html += f.error_messages
    html += "<table width='#{column_width*column_count}'>"
    row_fields.each do |row_field|
      html += "<tr>"
      row_field.each do |field|
        if field.is_a?(Hash)
          field_name = field[:field] # 字段名
          field_type = field[:type]  # 字段类型
          field_rows = field.has_key?(:rows) ? field[:rows] : 2  # 行数 area
          field_cols = field.has_key?(:cols) ? field[:cols] : 20 # 宽度 area
        else
          field_name = field
        end
#        field_disabled = controller.name=='show' ? true : false
        field_args = { :rows => field_rows, :cols => field_cols}
        field_args['disabled'] = 'true' if action == 'show'
        if not field.nil?
          if field_type == "text_area"
            #html += f.text_area(field_name, :rows => field_rows, :cols => field_cols)
            html += f.text_area(field_name, field_args)
          else
            html += f.text_field(field_name, field_args)
          end
        end
      end
      html += "</tr>"
    end
    html += "</table>"

    return html
  end

  # 调用jqgrid
  def jqgrid_index(fields, *args)
    html = ""

    # 获得基本变量
    controller_name = controller.controller_name
    name_single = controller_name.downcase.singularize
    class_name_cn = I18n.t("activerecord.models.#{name_single}")
    nav_end = { :add => true, :edit => true, :delete => true, :edit_url => "/#{controller_name}/post_data", :error_handler => "afterSubmit", :height => 450, :rows_per_page => 20, :selection_handler => "handleSelection"}
    #nav_end = { :add => true, :edit => true, :delete => true, :edit_url => "/#{controller_name}/post_data", :error_handler => "afterSubmit", :height => 450, :rows_per_page => 20, :selection_handler => "handleSelection", :inline_edit => true}

    # 若fields中无label，则补上
    fields.each_index do |index|
      fields[index] = { :label => I18n.t("activerecord.attributes.#{name_single}.#{fields[index][:field]}")}.merge(fields[index])
    end

    # fields数组 若第1、2个定义非id，则补上id字段
    if (not (fields[0][:field] == "id")) and (fields.size>1 and not (fields[1][:field] == "id"))
      fields.insert(0,{ :field => "id", :label => "ID", :width => 35, :resizable => false })
    end

    html += jqgrid(class_name_cn, "tableRecs", "/#{controller_name}", fields, nav_end)

    return html
  end
end

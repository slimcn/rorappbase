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

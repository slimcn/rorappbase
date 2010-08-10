# -*- coding: utf-8 -*-
class MainController < ApplicationController
  def index
    @html_menutree = get_tree_jquerymenutree
  end

  def get_tree
    json_data = ""
    if params[:type] == 'others' # 其它，不在表单菜单关系中的表单
      @forms = Form.find(:all, :conditions=>"id not in (select form_id from forms_menutrees)")
      json_data += get_menu_form_json(@forms)
    elsif params[:id] == 'false'
      if_root = true
      @menutrees = Menutree.find(:all,:conditions=>"parent_id is NULL or parent_id=0")
      json_data = get_menu_tree_json(@menutrees, if_root)
    else
      if_root = false
      @menutrees = Menutree.find(:all, :conditions => "parent_id = "+params[:id])
      json_data = get_menu_tree_json(@menutrees,if_root) unless @menutrees.blank?
      @forms = Menutree.find(params[:id]).forms
      json_data_forms = get_menu_form_json(@forms) unless @forms.blank?
      connect_sym = json_data.length>0 ? "," : ""
      json_data += connect_sym + json_data_forms unless @forms.blank?
    end

    json_data = "[" + json_data + "]"
    #
    respond_to do |format|
      format.json {render :text=>json_data}
    end
  end

  private
  def get_menu_tree_json(menus,if_root)
    json_data = String.new
    # json_data += "["
    if if_root
      menus.each do |menu|
        json_data += "{\"data\":\"#{menu.name}#{menu.code}\",\"attr\":{\"class\":\"folder\",\"id\":\"#{menu.id}\",\"code\":\"#{menu.code}\",\"name\":\"#{menu.name}\",\"type\":\"#{menu.class.name}\"},\"state\":\"closed\"}"
        json_data += "," unless menu == menus.last
      end
      # 顶级项目：其它（不在表单菜单关系中的表单）
      json_data += "," unless json_data.length < 1
      json_data += "{\"data\":\"其它\", \"attr\":{\"class\":\"folder\",\"id\":\"0\",\"code\":\"0\",\"name\":\"others\",\"type\":\"others\"},\"state\":\"closed\"}"
    else
      menus.each do |menu|
        json_data += "{\"data\":\"#{menu.name}#{menu.code}\",\"attr\":{\"class\":\"folder\",\"id\":\"#{menu.id}\",\"code\":\"#{menu.code}\",\"name\":\"#{menu.name}\",\"type\":\"#{menu.class.name}\"},\"state\":\"closed\"}"
        json_data += "," unless menu == menus.last
      end
    end
    # json_data += "]"
    return json_data
  end

  def get_menu_form_json(forms)
    json_data = String.new
    # json_data = "["
    forms.each do |form|
      json_data += "{\"data\":{\"title\":\"#{form.name_cn}#{form.code}\",\"attr\":{\"href\":\"/#{form.name.pluralize}\"}},\"attr\":{\"class\":\"file\",\"id\":\"#{form.id}\",\"code\":\"#{form.code}\",\"name\":\"#{form.name}\",\"type\":\"#{form.class.name}\"}}"
      json_data += "," unless form == forms.last
    end
    # json_data += "]"
    return json_data
  end

  def get_tree_jquerymenutree(node_id=0, node_type="Menutree")
    html = ""
    qry_condition = node_id.equal?(0) ? "parent_id is null or parent_id=0" : "parent_id="+node_id.to_s
    menus = Menutree.find(:all, :conditions => qry_condition)
    menus.each do |menu|
      html += "<li id=" + menu.id.to_s + " type='" + menu.class.name + "'><span class='folder'>" + menu.name + "[" + menu.code + "]" + "</span>"
      if not (menu.forms.blank? and menu.children.blank?)
        html += "<ul>"
        html += get_tree_jquerymenutree(menu.id, menu.class.name) unless menu.children.blank?
        menu.forms.each do |form|
          html += "<li><a href='/" + form.name.pluralize + "'>" + form.name_cn + "</a></li>"
        end
        html += "</ul>"
      end
      html += "</li>"
    end
    return html
  end
end

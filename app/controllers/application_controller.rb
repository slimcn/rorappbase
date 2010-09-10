# -*- coding: utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include AuthenticatedSystem

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'f0094159304d81cde1b7f5a572fc0567'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  before_filter :set_locale
  before_filter :login_required
  before_filter :set_current_user

  def record_operation_button
    btn_list = [["add","新增","E"],["update","修改","E"],["delete","删除","E"],["show","查看","E"],["refresh","刷新","E"],["search","查询","E"]]
    records = Flownode.find(:all, :order => "code", :conditions => "rec_type='A'")
    btn_list += records.collect { |p| [p.name, p.name_cn, p.rec_type]}
    return btn_list
  end

  def login_required
    @logined = logined_in?
    if not @logined
      redirect_to login_path
      flash[:notice] = nil
    # elsif access_denied
    elsif function_denied
      # redirect_to "/" # 重定向到起始页
      flash[:notice] = "访问受限"
    elsif id && !user_have_record
      flash[:notice] = "记录受限"
    else
      flash[:notice] = "允许访问"
    end
  end

#  def access_denied
  def function_denied
    #redirect_to login_path
    #controller_name action_name params[:id]
    if @current_user
      ret = auth_controllers(@current_user[:id]).include?(params[:controller]) &&
        auth_actions(@current_user[:id],params[:controller]).include?(params[:action])
    else
      # ret = false
      ret = true
    end
    return !ret
  end

  def current_user
    @current_user ||= (login_from_session || false)
  end

  # set code_rule in session, it's used in auto code
  def set_session_code_rule(id, seq)
    session[:code_rule] ||= Hash.new
    session[:code_rule][id] ||= Hash.new
    session[:code_rule][id][:seq] = seq
  end

  alias :logined_in? :current_user

  private
  def current_user=(new_user)
    session[:user] = new_user && new_user.id
    @current_user = new_user
  end

  def login_from_session
    self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def set_locale
    # update session if passed
    session[:locale] = params[:locale] if params[:locale]

    # set locale based on session or default
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def post_data

    # It's of course your role to add security / validation here

    record_class = eval(controller_name.singularize.titleize) # 此处转换对多单词无效，因此转到tm_scaffol中的controller模板中自动生成
    if params[:oper] == "del"
      record_class.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = record_class.create(record_params)
      else
        record = record_class.find(params[:id])
        record.update_attributes(record_params)
      end
    end

    # If you need to display error messages
    err = ""
    if record
      record.errors.entries.each do |error|
        err << "<strong>#{error[0]}</strong> : #{error[1]}<br/>"
      end
    end

    render :text => "#{err}"
  end

  def index
    record_class = eval(controller_name.singularize.titleize)

    field_array = []
    @sheet_fields.each do |field|
      field_array << field[:field].to_sym
    end

    records = record_class.find(:all ) do |x|
      if params[:_search] == "true"
        field_array.map do |m|
          x.send(m) =~ "%#{params[m]}%" if params[m].present?
        end
      end
      paginate :page => params[:page], :pre_page => params[:rows]
      order_by "#{params[:sidx]} #{params[:sord]}" if !params[:sidx].blank?
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => records }
      format.json { render :json => records.to_jqgrid_json(field_array.insert(0,:id),
                                                         params[:page], params[:rows], records.total_entries)}
    end

  end

  # get the list,such as select options [[value1,show1],[value2,show2]...]
  def get_records_format_data(class_name, fields, condition = nil)
    ret = []
    ret.push(["",""])
    class_name.find(:all).each do |rec|
      tmp = ""
      fields[1..fields.size-1].each do |field|
        tmp += " " if tmp.length > 0
        tmp += rec[field]
      end
      ret.push([rec[fields[0]], tmp])
    end
    return ret
  end

  # user‘s controller permition array: ["controller1","controller2"...]
  def auth_controllers(user_id)
    ret = []
    rec_operations = []
    rec_user = User.find(:first, :conditions => "id=" + user_id.to_s)
    if rec_user
      rec_roles = rec_user.roles
    else
      rec_roles = Role.find(:all)
    end
    rec_roles.each do |role|
      rec_operations += role.operations
    end
    rec_operations.collect do |ope|
      ret << ope[:url] if ope[:rec_type] == "form"
    end
    return ret
  end

  # user‘s actions permition array for a controller: ["action1","action2"...]
  def auth_actions(user_id, controller_name)
    ret = []
    rec_operations = []
    rec_user = User.find(:all, :conditions => "id=" + user_id.to_s)[0]
    if rec_user
      rec_roles = rec_user.roles
    else
      rec_roles = Role.find(:all)
    end
    rec_roles.each do |role|
      rec_operations += role.operations
    end
    rec_operations.collect do |ope|
      ope_parent = ope.parent
      if ope_parent
        ret << ope[:url] if (ope[:rec_type] == "action" and ope_parent[:rec_type] == "form" and ope_parent[:url]==controller_name)
      end
    end
    return ret
  end

  # User belongs to the department and its fathers
  def auth_user_belongs_to_departments(user_id)
    u = User.find(user_id)
    ds = u.department.ancestors
    return ds.collect { |rec| rec.id}
  end

  # User managed departments, return [id1,id2...]
  def auth_user_managed_departments(user_id)
    u = User.find(user_id)
#    arr_depts = u.employe.manageddepartments
#    u.employe.manageddepartments.each do |node|
#      node.progenies(node, arr_depts)
#    end
    arr_depts = Department.find(:all, :conditions => "incode like '" + u.employe.department.incode + "%'")
    return arr_depts.collect{|rec| rec.id}
  end

  # Records conditions limited by employes/departments
  #   employe can get self's record
  #   department manager can get self's record and records belongs to managed departments and progenies' departments
  def auth_records_condition(table_name = "")
    ret = ""
    table_pre = table_name.blank? ? '' : table_name + '.'
    class_name = params[:controller].titleize.sub(' ','').singularize.constantize
    if class_name.column_names.include?("employe_id")
      ret += " " + table_pre + "employe_id in (" +  @current_user.employe.id.to_s + ") "
    end
    if class_name.column_names.include?("department_id")
      str_managed_depart_id = auth_user_managed_departments(@current_user.id).join(',')
      ret += " or " + table_pre + "department_id in (" + str_managed_depart_id + ")" if not str_managed_depart_id.blank?
    end
    ret = "1=1" if ret.blank?

    return " (" + ret + ") "
  end

  def user_have_record(rec_id = nil, user_id=nil)
    rec_id ||= params[:id]
    if rec_id
      user_id ||= @current_user.id
      class_name = str_class_name(params[:controller])
      arr_rec = class_name.find(:all, :conditions => "id=" + rec_id.to_s +
                           " and " + auth_records_condition)
      ret = arr_rec.blank?
    else
      ret = false
    end
    return !ret
  end

  def str_class_name(str)
    return str.titleize.sub(' ','').singularize.constantize
  end

  # 初始化新的表单日志记录
  def flow_get_new_formlog(form)
    formlog = Formlog.new
    formlog.form_id = form.id
    formlog.form_type = form.class.name
    formlog.employe_id = @current_user.employe_id
    formlog.user_id = @current_user.id
    formlog.status = 0 # 新增状态
    return formlog
  end
  # 获得表单-审核流程对应
  def flow_get_auditflows_form(formlog)
    auditflows_form = AuditflowsForm.find(:first, :conditions=>"form_type='"+formlog.form_type+"' and form_id="+formlog.form_id.to_s)
    auditflows_form = flow_get_new_auditflows_form(formlog) if auditflows_form.blank?
    return auditflows_form
  end

  # 赋值表单日志、表单-流程对应关系的状态、记录状态
  def flow_set_rec_log_and_status(formlog, flow_form, form)
    t = Time.now
    is_allow = params[:submit] == 'allow' # 审核提交时的按钮：通过 or 驳回
    is_unaudit = params[:button_name] == 'audit_unaudit' # 审核操作按钮：反审
    str_allow = '' # 通过 or 驳回

    formlog.remarks = @current_user.employe.name + "(" + @current_user.login + ")于" +
      t.strftime("%Y年%m月%d日 %H:%M:%S") + "做了" +
      "#{params[:button_name_cn]}" + I18n.t("#{params[:submit]}") + "操作"
    formlog.auditflows_flownode_id = flow_form.auditflows_flownode_id # 当前流程点
    before_sequence = is_unaudit ? Auditflow.find(flow_form.auditflow_id).auditflows_flownodes.last :
      AuditflowsFlownode.pre_flownode(flow_form.auditflows_flownode)
    formlog.before_sequence_id = before_sequence.id if before_sequence
    after_sequence = is_unaudit ? Auditflow.find(flow_form.auditflow_id).auditflows_flownodes.first :
      AuditflowsFlownode.next_flownode(flow_form.auditflows_flownode)
    formlog.after_sequence_id = after_sequence.id if after_sequence
    flow_form.auditflows_flownode_id = formlog.after_sequence_id # 表单-流程对应中的流程点为下一可用操作
    if form.attribute_names.include?("status") # 设置记录状态
      if (not is_allow) || is_unaudit
        form.status = "0" if (form.status >= "1000") # 表单-流程关系尚未永久保存，为审核流程开始，则设置记录状态为审核完成
      elsif flow_form.id.blank? || (form.status != "1000") # 表单-流程关系尚未永久保存，为审核流程开始，则设置记录状态为审核完成
        form.status = "1000"
      elsif after_sequence.blank? || (after_sequence.flownode.name=='audit_unaudit') # 无后续流程，或后续流程为反审，则设置记录状态为审核完成
        form.status = "6000"
      end
    end

    return formlog, flow_form, form
  end

  # 检查所做操作是否为当前可执行的动作
  def flow_is_need_action_on_flow(rec, action_name)
    auditflow = AuditflowsForm.find(:first, :conditions=>"form_id=#{@rordemo.id} and form_type='#{@rordemo.class.name}'" )
    if auditflow
      flownode_name = auditflow.auditflows_flownode.flownode.name if auditflow.auditflows_flownode && auditflow.auditflows_flownode.flownode
      flownode_name = (auditflow.auditflows_flownode && auditflow.auditflows_flownode.flownode) ? auditflow.auditflows_flownode.flownode.name : "audit_unaudit"
    else
      flownode_name = "audit_self"
    end
    return flownode_name == action_name
  end

  protected
  def set_current_user
    User.current_user = self.current_user
  end

  private
  # 获得新的表单-审核流程对应
  def flow_get_new_auditflows_form(formlog)
    auditflows_form = AuditflowsForm.new()
    # auditflow = get_auditflow_with_form(formlog.form_type, formlog.form_id)
    auditflow = Auditflow.find(1)
    auditflows_form.form_id, auditflows_form.form_type, auditflows_form.auditflow_id = formlog.form_id, formlog.form_type, auditflow.id
    # AuditflowsForm.auditflows_flownode_id 表示下一步将进行的操作
    auditflows_form.auditflows_flownode_id = auditflow.auditflows_flownodes[0].id if auditflow.auditflows_flownodes
    return auditflows_form
  end

end

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

  def login_required
    @logined = logined_in?
    if not @logined
      redirect_to login_path
      flash[:notice] = nil
    elsif access_denied
      redirect_to "/" # 重定向到起始页
      flash[:notice] = "访问受限"
    else
      flash[:notice] = nil
    end
  end

  def access_denied
    #redirect_to login_path
    #controller_name action_name params[:id]
    if @current_user
      ret = auth_controllers(@current_user[:id]).include?(controller_name) &&
                 auth_actions(@current_user[:id],controller_name).include?(action_name)
    else
      ret = true
    end
    return !ret
  end

  def current_user
    @current_user ||= (login_from_session || false)
  end

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
    rec_user = []
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
    rec_user = []
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

  protected
  def set_current_user
    User.current_user = self.current_user
  end
end

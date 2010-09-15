# -*- coding: utf-8 -*-
class <%= controller_class_name %>Controller < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "<%= controller_singular_name %>",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = <%= attr_fields %>
    @sheet_detail_fields = '<%= attr_detail_fields || [] %>'
    fields = @sheet_fields.collect { |q| q[:field]}
    @sheet_fields_no_id = fields.collect { |q| ":"+q}.join(", ")
    @sheet_fields_no_id_params = fields.collect { |q| ":#{q} => params[:#{q}]"}.join(", ")
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      <%= class_name %>.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = <%= class_name %>.create(record_params)
      else
        record = <%= class_name %>.find(params[:id])
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
    field_array = []
    @sheet_fields.each do |field|
      field_array << field[:field].to_sym
    end

    records = <%= class_name %>.find(:all ) do |x|
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


  # GET /<%= table_name %>/1
  # GET /<%= table_name %>/1.xml
  def show
    @<%= file_name %> = <%= class_name %>.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @<%= file_name %> }
    end
  end

  # GET /<%= table_name %>/new
  # GET /<%= table_name %>/new.xml
  def new
    @<%= file_name %> = <%= class_name %>.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @<%= file_name %> }
    end
  end

  # GET /<%= table_name %>/1/edit
  def edit
    @<%= file_name %> = <%= class_name %>.find(params[:id])
  end

  # POST /<%= table_name %>
  # POST /<%= table_name %>.xml
  def create
    @<%= file_name %> = <%= class_name %>.new(params[:<%= file_name %>])

    respond_to do |format|
      if @<%= file_name %>.save
        flash[:notice] = '<%= class_name %> was successfully created.'
        format.html { redirect_to(@<%= file_name %>) }
        format.xml  { render :xml => @<%= file_name %>, :status => :created, :location => @<%= file_name %> }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /<%= table_name %>/1
  # PUT /<%= table_name %>/1.xml
  def update
    @<%= file_name %> = <%= class_name %>.find(params[:id])

    respond_to do |format|
      if @<%= file_name %>.update_attributes(params[:<%= file_name %>])
        flash[:notice] = '<%= class_name %> was successfully updated.'
        format.html { redirect_to(@<%= file_name %>) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /<%= table_name %>/1
  # DELETE /<%= table_name %>/1.xml
  def destroy
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    @<%= file_name %>.destroy

    respond_to do |format|
      format.html { redirect_to(<%= table_name %>_url) }
      format.xml  { head :ok }
    end
  end

  # PUT /<%= table_name %>/1/audit
  # PUT /<%= table_name %>/1.xml/audit
  def audit
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    @formlog = Formlog.new(params[:formlog])
    @auditflows_form = flow_get_auditflows_form(@formlog) # 获得表单-审核流程对应，没有对应(自检)时获得新的对应（未存入数据库）
    if @auditflows_form.auditflows_flownode || flow_is_need_action_on_flow(@<%= file_name %>, params[:button_name])
      # 设定审核操作相关值
      @formlog, @auditflows_form, @<%= file_name %> = flow_set_rec_log_and_status(@formlog, @auditflows_form, @<%= file_name %>)
    else  # 审核流程已经结束
      flash[:notice] = "审核流程已结束，请勿重复操作！"
      render :action => "show"
      return
    end

    respond_to do |format|
      begin
        <%= class_name %>.transaction do
          @formlog.save!
          @auditflows_form.save!
          @<%= file_name %>.save!
          flash[:notice] = '审核完成.'
          format.html { redirect_to(@<%= file_name %>) }
          format.xml  { render :xml => @formlog, :status => :created, :location => @formlog }
        end
        rescue
        format.html { render :action => "audit_self" }
        format.xml  { render :xml => @formlog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # get /<%= table_name %>/1/audit_self
  def audit_self
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    @button_name, @button_name_cn = params[:button_name], params[:button_name_cn]
    if not flow_is_need_action_on_flow(@<%= file_name %>, @button_name) # 是否为当前要操作的节点
      flash[:notice] = '操作流程不允许'
      render :action => "show"
      return
    end
    @formlog = flow_get_new_formlog(@<%= file_name %>)
  end

end

# -*- coding: utf-8 -*-
class RordemosController < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "rordemo",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'code', :width => 80, :editable => true},
                     { :field => 'name', :width => 80, :editable => true},
                     { :field => 'recordtype', :width => 80, :editable => true},
                     { :field => 'status', :width => 80, :editable => true},
                     { :field => 'employe_id', :width => 80, :editable => true},
                     { :field => 'department_id', :width => 80, :editable => true},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = ''
    @sheet_fields_no_id = ":code, :name, :recordtype, :status, :employe_id, :department_id, :remarks"
    @sheet_fields_no_id_params = ":code => params[:code], :name => params[:name], :recordtype => params[:recordtype], :status => params[:status], :employe_id => params[:employe_id], :department_id => params[:department_id], :remarks => params[:remarks]"
    @sheet_fields_type = "code:text_field name:text_field recordtype:text_field status:text_field employe_id:text_field department_id:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      Rordemo.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = Rordemo.create(record_params)
      else
        record = Rordemo.find(params[:id])
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

    records = Rordemo.find(:all ) do |x|
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

  def record_operation_button
    return [["add","新增"],["update","修改"],["delete","删除"],["show","查看"],["refresh","刷新"],["search","查询"],["audit_self","自检"],["audit_ywjl","业务经理"]]
  end

  # GET /rordemos/1
  # GET /rordemos/1.xml
  def show
    @rordemo = Rordemo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rordemo }
    end
  end

  # GET /rordemos/new
  # GET /rordemos/new.xml
  def new
    @rordemo = Rordemo.new
    @code, @code_pre, @code_max_seq, @code_rule_id = CodeRule.code_rules_to_get_code(Rordemo.table_name)
    @rordemo.code_rule = CodeRule.find_by_id(@code_rule_id)
    @rordemo.code_rule.seq = @code_max_seq
    set_session_code_rule(@code_rule_id, @code_max_seq)
    @employe_id = @current_user.employe_id
    @department_id = @current_user.employe.department_id

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rordemo }
    end
  end

  # GET /rordemos/1/edit
  def edit
    @rordemo = Rordemo.find(params[:id])
  end

  # POST /rordemos
  # POST /rordemos.xml
  def create
    @rordemo = Rordemo.new(params[:rordemo])

    respond_to do |format|
      begin
        Rordemo.transaction do
          @rordemo.save!
          if session[:code_rule][@rordemo.code_rule_id][:seq] > @rordemo.code_rule.seq
            @rordemo.code_rule.seq = session[:code_rule][@rordemo.code_rule_id][:seq]
          end
          @rordemo.code_rule.save!
          flash[:notice] = 'Rordemo was successfully created.'
          format.html { redirect_to(@rordemo) }
          format.xml  { render :xml => @rordemo, :status => :created, :location => @rordemo }
        end
      rescue
        format.html { render :action => "new" }
        format.xml  { render :xml => @rordemo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rordemos/1
  # PUT /rordemos/1.xml
  def update
    @rordemo = Rordemo.find(params[:id])

    respond_to do |format|
      if @rordemo.update_attributes(params[:rordemo])
        flash[:notice] = 'Rordemo was successfully updated.'
        format.html { redirect_to(@rordemo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rordemo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rordemos/1
  # DELETE /rordemos/1.xml
  def destroy
    @rordemo = Rordemo.find(params[:id])
    @rordemo.destroy

    respond_to do |format|
      format.html { redirect_to(rordemos_url) }
      format.xml  { head :ok }
    end
  end

  # PUT /rordemos/1/audit
  # PUT /rordemos/1.xml/audit
  def audit
    @rordemo = Rordemo.find(params[:id])
      @formlog = Formlog.new(params[:formlog])
      @auditflows_form = AuditflowsForm.find(:first, :conditions=>"form_type='"+@formlog.form_type+"' and form_id="+@formlog.form_id.to_s)
      # 没有审核流程关系(自检)时设定表单审核流程关系
      @auditflows_form = get_new_auditflows_form(@formlog) if @auditflows_form.blank?
    if @auditflows_form.auditflows_flownode # 判断审核流程是否结束
      # 设定审核操作相关值
      @formlog.auditflows_flownode_id = @auditflows_form.auditflows_flownode_id
      #报错：can't convert Symbol into String。 @formlog.before_sequence = @auditflows_form.auditflows_flownode.pre_flownode
      before_sequence = AuditflowsFlownode.pre_flownode(@auditflows_form.auditflows_flownode)
      @formlog.before_sequence_id = before_sequence.id if before_sequence
      after_sequence = AuditflowsFlownode.next_flownode(@auditflows_form.auditflows_flownode)
      @formlog.after_sequence_id = after_sequence.id if after_sequence
      @auditflows_form.auditflows_flownode_id = @formlog.after_sequence_id
      # @auditflows_form.auditflows_flownode_id = AuditflowsFlownode.next_flownode(@auditflows_form.auditflows_flownode) if @auditflows_form.auditflows_flownode
      @rordemo.status="6000" if @auditflows_form.auditflows_flownode_id.blank?  # 设置记录状态为审核完成
    else  # 审核流程已经结束
      flash[:notice] = "审核流程已结束，请勿重复操作！"
      render :action => "show"
      return
    end

    respond_to do |format|
      begin
        Rordemo.transaction do
          @formlog.save!
          @auditflows_form.save!
          flash[:notice] = '审核完成.'
          format.html { redirect_to(@rordemo) }
          format.xml  { render :xml => @formlog, :status => :created, :location => @formlog }
        end
        rescue
        format.html { render :action => "audit_self" }
        format.xml  { render :xml => @formlog.errors, :status => :unprocessable_entity }
      end
    end
  end

  def get_new_auditflows_form(formlog)
    @auditflows_form = AuditflowsForm.new()
    # auditflow = get_auditflow_with_form(formlog.form_type, formlog.form_id)
    auditflow = Auditflow.find(1)
    @auditflows_form.form_id, @auditflows_form.form_type, @auditflows_form.auditflow_id = @formlog.form_id, @formlog.form_type, auditflow.id
    # AuditflowsForm.auditflows_flownode_id 表示下一步将进行的操作
    @auditflows_form.auditflows_flownode_id = auditflow.auditflows_flownodes[0].id if auditflow.auditflows_flownodes
    return @auditflows_form
  end

  # get /rordemos/1/audit_self
  def audit_self
    @rordemo = Rordemo.find(params[:id])
    @formlog = Formlog.new
    @formlog.form_id = @rordemo.id
    @formlog.form_type = @rordemo.class.name
    @formlog.employe_id = @current_user.employe_id
    @formlog.user_id = @current_user.id

    @formlog.status = 0 # 新增状态
  end

end

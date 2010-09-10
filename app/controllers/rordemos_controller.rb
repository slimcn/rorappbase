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
                     { :field => 'remarks', :width => 80, :editable => true},
                     { :field => 'auditflow_id', :width => 80, :editable => true},
                     { :field => 'auditflows_flownode_id', :width => 80, :editable => true},
                     { :field => 'auditflows_flownode_name', :width => 80, :editable => true},
                    ]
    @sheet_detail_fields = ''
    fields = @sheet_fields.collect { |q| q[:field]}
    @sheet_fields_no_id = fields.collect { |q| ":"+q}.join(", ")
    @sheet_fields_no_id_params = fields.collect { |q| ":#{q} => params[:#{q}]"}.join(", ")
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
    @auditflows_form = flow_get_auditflows_form(@formlog) # 获得表单-审核流程对应，没有对应(自检)时获得新的对应（未存入数据库）
    if @auditflows_form.auditflows_flownode || flow_is_need_action_on_flow(@rordemo, params[:button_name])
      # 设定审核操作相关值
      @formlog, @auditflows_form, @rordemo = flow_set_rec_log_and_status(@formlog, @auditflows_form, @rordemo)
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
          @rordemo.save!
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

  # get /rordemos/1/audit_self
  def audit_self
    @rordemo = Rordemo.find(params[:id])
    @button_name, @button_name_cn = params[:button_name], params[:button_name_cn]
    if not flow_is_need_action_on_flow(@rordemo, @button_name) # 是否为当前要操作的节点
      flash[:notice] = '操作流程不允许'
      render :action => "show"
      return
    end
    @formlog = flow_get_new_formlog(@rordemo)
  end

end

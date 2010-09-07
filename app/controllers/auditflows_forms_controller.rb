# -*- coding: utf-8 -*-
class AuditflowsFormsController < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "AuditflowsForm",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'form_id', :width => 80, :editable => true},
                     { :field => 'auditflow_id', :width => 80, :editable => true},
                     { :field => 'form_type', :width => 80, :editable => true},
                     { :field => 'auditflows_flownode_id', :width => 80, :editable => true},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = ''
    @sheet_fields_no_id = ":form_id, :auditflow_id, :form_type, :auditflows_flownode_id, :remarks"
    @sheet_fields_no_id_params = ":form_id => params[:form_id], :auditflow_id => params[:auditflow_id], :form_type => params[:form_type], :auditflows_flownode_id => params[:auditflows_flownode_id], :remarks => params[:remarks]"
    @sheet_fields_type = "form_id:text_field auditflow_id:text_field form_type:text_field auditflows_flownode_id:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      AuditflowsForm.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = AuditflowsForm.create(record_params)
      else
        record = AuditflowsForm.find(params[:id])
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

    records = AuditflowsForm.find(:all ) do |x|
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


  # GET /auditflows_forms/1
  # GET /auditflows_forms/1.xml
  def show
    @auditflows_form = AuditflowsForm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @auditflows_form }
    end
  end

  # GET /auditflows_forms/new
  # GET /auditflows_forms/new.xml
  def new
    @auditflows_form = AuditflowsForm.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @auditflows_form }
    end
  end

  # GET /auditflows_forms/1/edit
  def edit
    @auditflows_form = AuditflowsForm.find(params[:id])
  end

  # POST /auditflows_forms
  # POST /auditflows_forms.xml
  def create
    @auditflows_form = AuditflowsForm.new(params[:auditflows_form])

    respond_to do |format|
      if @auditflows_form.save
        flash[:notice] = 'AuditflowsForm was successfully created.'
        format.html { redirect_to(@auditflows_form) }
        format.xml  { render :xml => @auditflows_form, :status => :created, :location => @auditflows_form }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @auditflows_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /auditflows_forms/1
  # PUT /auditflows_forms/1.xml
  def update
    @auditflows_form = AuditflowsForm.find(params[:id])

    respond_to do |format|
      if @auditflows_form.update_attributes(params[:auditflows_form])
        flash[:notice] = 'AuditflowsForm was successfully updated.'
        format.html { redirect_to(@auditflows_form) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @auditflows_form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /auditflows_forms/1
  # DELETE /auditflows_forms/1.xml
  def destroy
    @auditflows_form = AuditflowsForm.find(params[:id])
    @auditflows_form.destroy

    respond_to do |format|
      format.html { redirect_to(auditflows_forms_url) }
      format.xml  { head :ok }
    end
  end

  def set_auditflows_flownodes
    @rec = Auditflow.find(params[:id])
    options_html = "<option value=''></option>"
    @rec.auditflows_flownodes.each do |r|
      options_html += "<option value='" + r.id.to_s + "'>" + r.sequence.to_s+r.flownode.code+r.flownode.name_cn + "</option>"
    end
    render :update do |page|
      page << '$j("#auditflows_form_auditflows_flownode_id").empty();$j("#auditflows_form_auditflows_flownode_id").prepend("' + options_html + '");'
    end
  end

  def set_form_type
    @rec = Form.find(params[:id])
    form_type = str_class_name(@rec.name)
    render :update do |page|
      page << "$j('#auditflows_form_form_type').attr('value','#{form_type}')"
    end
  end

end

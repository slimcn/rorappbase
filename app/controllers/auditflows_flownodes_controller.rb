# -*- coding: utf-8 -*-
class AuditflowsFlownodesController < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "AuditflowsFlownode",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'auditflow_id', :width => 80, :editable => true},
                     { :field => 'flownode_id', :width => 80, :editable => true},
                     { :field => 'sequence', :width => 80, :editable => true},
                     { :field => 'name', :width => 80, :editable => true},
                     { :field => 'role_id', :width => 80, :editable => true},
                     { :field => 'rec_type', :width => 80, :editable => true},
                     { :field => 'status', :width => 80, :editable => true},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = ''
    @sheet_fields_no_id = ":auditflow_id, :flownode_id, :sequence, :name, :role_id, :rec_type, :status, :remarks"
    @sheet_fields_no_id_params = ":auditflow_id => params[:auditflow_id], :flownode_id => params[:flownode_id], :sequence => params[:sequence], :name => params[:name], :role_id => params[:role_id], :rec_type => params[:rec_type], :status => params[:status], :remarks => params[:remarks]"
    @sheet_fields_type = "auditflow_id:text_field flownode_id:text_field sequence:text_field name:text_field role_id:text_field rec_type:text_field status:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      AuditflowsFlownode.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = AuditflowsFlownode.create(record_params)
      else
        record = AuditflowsFlownode.find(params[:id])
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

    records = AuditflowsFlownode.find(:all ) do |x|
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


  # GET /auditflows_flownodes/1
  # GET /auditflows_flownodes/1.xml
  def show
    @auditflows_flownode = AuditflowsFlownode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @auditflows_flownode }
    end
  end

  # GET /auditflows_flownodes/new
  # GET /auditflows_flownodes/new.xml
  def new
    @auditflows_flownode = AuditflowsFlownode.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @auditflows_flownode }
    end
  end

  # GET /auditflows_flownodes/1/edit
  def edit
    @auditflows_flownode = AuditflowsFlownode.find(params[:id])
  end

  # POST /auditflows_flownodes
  # POST /auditflows_flownodes.xml
  def create
    @auditflows_flownode = AuditflowsFlownode.new(params[:auditflows_flownode])

    respond_to do |format|
      if @auditflows_flownode.save
        flash[:notice] = 'AuditflowsFlownode was successfully created.'
        format.html { redirect_to(@auditflows_flownode) }
        format.xml  { render :xml => @auditflows_flownode, :status => :created, :location => @auditflows_flownode }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @auditflows_flownode.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /auditflows_flownodes/1
  # PUT /auditflows_flownodes/1.xml
  def update
    @auditflows_flownode = AuditflowsFlownode.find(params[:id])

    respond_to do |format|
      if @auditflows_flownode.update_attributes(params[:auditflows_flownode])
        flash[:notice] = 'AuditflowsFlownode was successfully updated.'
        format.html { redirect_to(@auditflows_flownode) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @auditflows_flownode.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /auditflows_flownodes/1
  # DELETE /auditflows_flownodes/1.xml
  def destroy
    @auditflows_flownode = AuditflowsFlownode.find(params[:id])
    @auditflows_flownode.destroy

    respond_to do |format|
      format.html { redirect_to(auditflows_flownodes_url) }
      format.xml  { head :ok }
    end
  end
end

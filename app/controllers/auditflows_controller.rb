# -*- coding: utf-8 -*-
class AuditflowsController < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "auditflow",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'code', :width => 80, :editable => true},
                     { :field => 'name', :width => 80, :editable => true},
                     { :field => 'name_cn', :width => 80, :editable => true},
                     { :field => 'condition', :width => 80, :editable => true},
                     { :field => 'rec_type', :width => 80, :editable => true},
                     { :field => 'status', :width => 80, :editable => true},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = [{ :field => 'flownode_id', :width => 80, :editable => true},
                     { :field => 'sequence', :width => 80, :editable => true},
                     { :field => 'name', :width => 80, :editable => true},
                     { :field => 'role_id', :width => 80, :editable => true},
                     { :field => 'rec_type', :width => 80, :editable => true},
                     { :field => 'status', :width => 80, :editable => true},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_fields_no_id = ":code, :name, :name_cn, :condition, :rec_type, :status, :remarks"
    @sheet_fields_no_id_params = ":code => params[:code], :name => params[:name], :name_cn => params[:name_cn], :condition => params[:condition], :rec_type => params[:rec_type], :status => params[:status], :remarks => params[:remarks]"
    @sheet_fields_type = "code:text_field name:text_field name_cn:text_field condition:text_area rec_type:text_field status:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      Auditflow.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = Auditflow.create(record_params)
      else
        record = Auditflow.find(params[:id])
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

    records = Auditflow.find(:all ) do |x|
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


  # GET /auditflows/1
  # GET /auditflows/1.xml
  def show
    @auditflow = Auditflow.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @auditflow }
    end
  end

  # GET /auditflows/new
  # GET /auditflows/new.xml
  def new
    @auditflow = Auditflow.new
    1.times { @auditflow.auditflows_flownodes.build}

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @auditflow }
    end
  end

  # GET /auditflows/1/edit
  def edit
    @auditflow = Auditflow.find(params[:id])
  end

  # POST /auditflows
  # POST /auditflows.xml
  def create
    @auditflow = Auditflow.new(params[:auditflow])

    respond_to do |format|
      if @auditflow.save
        flash[:notice] = 'Auditflow was successfully created.'
        format.html { redirect_to(@auditflow) }
        format.xml  { render :xml => @auditflow, :status => :created, :location => @auditflow }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @auditflow.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /auditflows/1
  # PUT /auditflows/1.xml
  def update
    @auditflow = Auditflow.find(params[:id])

    respond_to do |format|
      if @auditflow.update_attributes(params[:auditflow])
        flash[:notice] = 'Auditflow was successfully updated.'
        format.html { redirect_to(@auditflow) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @auditflow.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /auditflows/1
  # DELETE /auditflows/1.xml
  def destroy
    @auditflow = Auditflow.find(params[:id])
    @auditflow.destroy

    respond_to do |format|
      format.html { redirect_to(auditflows_url) }
      format.xml  { head :ok }
    end
  end
end

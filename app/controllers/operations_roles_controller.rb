# -*- coding: utf-8 -*-
class OperationsRolesController < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "OperationsRole",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'role_id', :width => 80, :editable => true, :edittype => "select",
                       :editoptions => { :value => get_records_format_data(Role, [:id, :name])}},
                     { :field => 'operation_id', :width => 80, :editable => true, :edittype => "select",
                       :editoptions => { :value => get_records_format_data(Operation,[:id, :code,:name])}},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = ''
    @sheet_fields_no_id = ":role_id, :operation_id, :remarks"
    @sheet_fields_no_id_params = ":role_id => params[:role_id], :operation_id => params[:operation_id], :remarks => params[:remarks]"
    @sheet_fields_type = "role_id:text_field operation_id:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      OperationsRole.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = OperationsRole.create(record_params)
      else
        record = OperationsRole.find(params[:id])
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

    records = OperationsRole.find(:all ) do |x|
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


  # GET /operations_roles/1
  # GET /operations_roles/1.xml
  def show
    @operations_role = OperationsRole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @operations_role }
    end
  end

  # GET /operations_roles/new
  # GET /operations_roles/new.xml
  def new
    @operations_role = OperationsRole.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @operations_role }
    end
  end

  # GET /operations_roles/1/edit
  def edit
    @operations_role = OperationsRole.find(params[:id])
  end

  # POST /operations_roles
  # POST /operations_roles.xml
  def create
    @operations_role = OperationsRole.new(params[:operations_role])

    respond_to do |format|
      if @operations_role.save
        flash[:notice] = 'OperationsRole was successfully created.'
        format.html { redirect_to(@operations_role) }
        format.xml  { render :xml => @operations_role, :status => :created, :location => @operations_role }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @operations_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /operations_roles/1
  # PUT /operations_roles/1.xml
  def update
    @operations_role = OperationsRole.find(params[:id])

    respond_to do |format|
      if @operations_role.update_attributes(params[:operations_role])
        flash[:notice] = 'OperationsRole was successfully updated.'
        format.html { redirect_to(@operations_role) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @operations_role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /operations_roles/1
  # DELETE /operations_roles/1.xml
  def destroy
    @operations_role = OperationsRole.find(params[:id])
    @operations_role.destroy

    respond_to do |format|
      format.html { redirect_to(operations_roles_url) }
      format.xml  { head :ok }
    end
  end
end

# -*- coding: utf-8 -*-
class DepartmentmanagersController < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "Departmentmanager",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'department_id', :width => 80, :editable => true, :edittype => "select",
                       :editoptions => { :value => get_records_format_data(Department, [:id,:code,:name])}},
                     { :field => 'employe_id', :width => 80, :editable => true, :edittype => "select",
                       :editoptions => { :value => get_records_format_data(Employe, [:id,:code,:name])}}]
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = ''
    @sheet_fields_no_id = ":department_id, :employe_id, :remarks"
    @sheet_fields_no_id_params = ":department_id => params[:department_id], :employe_id => params[:employe_id], :remarks => params[:remarks]"
    @sheet_fields_type = "department_id:text_field employe_id:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      Departmentmanager.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = Departmentmanager.create(record_params)
      else
        record = Departmentmanager.find(params[:id])
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

    records = Departmentmanager.find(:all ) do |x|
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


  # GET /departmentmanagers/1
  # GET /departmentmanagers/1.xml
  def show
    @departmentmanager = Departmentmanager.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @departmentmanager }
    end
  end

  # GET /departmentmanagers/new
  # GET /departmentmanagers/new.xml
  def new
    @departmentmanager = Departmentmanager.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @departmentmanager }
    end
  end

  # GET /departmentmanagers/1/edit
  def edit
    @departmentmanager = Departmentmanager.find(params[:id])
  end

  # POST /departmentmanagers
  # POST /departmentmanagers.xml
  def create
    @departmentmanager = Departmentmanager.new(params[:departmentmanager])

    respond_to do |format|
      if @departmentmanager.save
        flash[:notice] = 'Departmentmanager was successfully created.'
        format.html { redirect_to(@departmentmanager) }
        format.xml  { render :xml => @departmentmanager, :status => :created, :location => @departmentmanager }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @departmentmanager.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /departmentmanagers/1
  # PUT /departmentmanagers/1.xml
  def update
    @departmentmanager = Departmentmanager.find(params[:id])

    respond_to do |format|
      if @departmentmanager.update_attributes(params[:departmentmanager])
        flash[:notice] = 'Departmentmanager was successfully updated.'
        format.html { redirect_to(@departmentmanager) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @departmentmanager.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /departmentmanagers/1
  # DELETE /departmentmanagers/1.xml
  def destroy
    @departmentmanager = Departmentmanager.find(params[:id])
    @departmentmanager.destroy

    respond_to do |format|
      format.html { redirect_to(departmentmanagers_url) }
      format.xml  { head :ok }
    end
  end
end

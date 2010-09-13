# -*- coding: utf-8 -*-
class EmployesController < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "Employe",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'code', :width => 80, :editable => true},
                     { :field => 'name', :width => 80, :editable => true},
                     { :field => 'department_id', :width => 80, :editable => true, :edittype => "select",
                       :editoptions => { :value => get_records_format_data(Department, [:id,:code,:name])}},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = ''
    @sheet_fields_no_id = ":code, :name, :department_id, :remarks"
    @sheet_fields_no_id_params = ":code => params[:code], :name => params[:name], :department_id => params[:department_id], :remarks => params[:remarks]"
    @sheet_fields_type = "code:text_field name:text_field department_id:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      Employe.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = Employe.create(record_params)
      else
        record = Employe.find(params[:id])
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

    records = Employe.find(:all ) do |x|
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


  # GET /employes/1
  # GET /employes/1.xml
  def show
    @employe = Employe.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @employe }
    end
  end

  # GET /employes/new
  # GET /employes/new.xml
  def new
    @employe = Employe.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @employe }
    end
  end

  # GET /employes/1/edit
  def edit
    @employe = Employe.find(params[:id])
  end

  # POST /employes
  # POST /employes.xml
  def create
    @employe = Employe.new(params[:employe])

    respond_to do |format|
      if @employe.save
        flash[:notice] = 'Employe was successfully created.'
        format.html { redirect_to(@employe) }
        format.xml  { render :xml => @employe, :status => :created, :location => @employe }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @employe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /employes/1
  # PUT /employes/1.xml
  def update
    @employe = Employe.find(params[:id])

    respond_to do |format|
      if @employe.update_attributes(params[:employe])
        flash[:notice] = 'Employe was successfully updated.'
        format.html { redirect_to(@employe) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @employe.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /employes/1
  # DELETE /employes/1.xml
  def destroy
    @employe = Employe.find(params[:id])
    @employe.destroy

    respond_to do |format|
      format.html { redirect_to(employes_url) }
      format.xml  { head :ok }
    end
  end
end

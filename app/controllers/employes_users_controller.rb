# -*- coding: utf-8 -*-
class EmployesUsersController < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "EmployesUser",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'user_id', :width => 80, :editable => true},
                     { :field => 'employe_id', :width => 80, :editable => true},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = ''
    @sheet_fields_no_id = ":user_id, :employe_id, :remarks"
    @sheet_fields_no_id_params = ":user_id => params[:user_id], :employe_id => params[:employe_id], :remarks => params[:remarks]"
    @sheet_fields_type = "user_id:text_field employe_id:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      EmployesUser.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = EmployesUser.create(record_params)
      else
        record = EmployesUser.find(params[:id])
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

    records = EmployesUser.find(:all ) do |x|
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


  # GET /employes_users/1
  # GET /employes_users/1.xml
  def show
    @employes_user = EmployesUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @employes_user }
    end
  end

  # GET /employes_users/new
  # GET /employes_users/new.xml
  def new
    @employes_user = EmployesUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @employes_user }
    end
  end

  # GET /employes_users/1/edit
  def edit
    @employes_user = EmployesUser.find(params[:id])
  end

  # POST /employes_users
  # POST /employes_users.xml
  def create
    @employes_user = EmployesUser.new(params[:employes_user])

    respond_to do |format|
      if @employes_user.save
        flash[:notice] = 'EmployesUser was successfully created.'
        format.html { redirect_to(@employes_user) }
        format.xml  { render :xml => @employes_user, :status => :created, :location => @employes_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @employes_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /employes_users/1
  # PUT /employes_users/1.xml
  def update
    @employes_user = EmployesUser.find(params[:id])

    respond_to do |format|
      if @employes_user.update_attributes(params[:employes_user])
        flash[:notice] = 'EmployesUser was successfully updated.'
        format.html { redirect_to(@employes_user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @employes_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /employes_users/1
  # DELETE /employes_users/1.xml
  def destroy
    @employes_user = EmployesUser.find(params[:id])
    @employes_user.destroy

    respond_to do |format|
      format.html { redirect_to(employes_users_url) }
      format.xml  { head :ok }
    end
  end
end

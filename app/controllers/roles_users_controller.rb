# -*- coding: utf-8 -*-
class RolesUsersController < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "RolesUser",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'user_id', :width => 80, :editable => true, :edittype => "select",
                       :editoptions => { :value => get_records_format_data(User, [:id,:login])}},
                     { :field => 'role_id', :width => 80, :editable => true, :edittype => "select",
                       :editoptions => { :value => get_records_format_data(Role, [:id, :name])}},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = ''
    @sheet_fields_no_id = ":user_id, :role_id, :remarks"
    @sheet_fields_no_id_params = ":user_id => params[:user_id], :role_id => params[:role_id], :remarks => params[:remarks]"
    @sheet_fields_type = "user_id:text_field role_id:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      RolesUser.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = RolesUser.create(record_params)
      else
        record = RolesUser.find(params[:id])
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

    records = RolesUser.find(:all ) do |x|
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


  # GET /roles_users/1
  # GET /roles_users/1.xml
  def show
    @roles_user = RolesUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @roles_user }
    end
  end

  # GET /roles_users/new
  # GET /roles_users/new.xml
  def new
    @roles_user = RolesUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @roles_user }
    end
  end

  # GET /roles_users/1/edit
  def edit
    @roles_user = RolesUser.find(params[:id])
  end

  # POST /roles_users
  # POST /roles_users.xml
  def create
    @roles_user = RolesUser.new(params[:roles_user])

    respond_to do |format|
      if @roles_user.save
        flash[:notice] = 'RolesUser was successfully created.'
        format.html { redirect_to(@roles_user) }
        format.xml  { render :xml => @roles_user, :status => :created, :location => @roles_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @roles_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /roles_users/1
  # PUT /roles_users/1.xml
  def update
    @roles_user = RolesUser.find(params[:id])

    respond_to do |format|
      if @roles_user.update_attributes(params[:roles_user])
        flash[:notice] = 'RolesUser was successfully updated.'
        format.html { redirect_to(@roles_user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @roles_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /roles_users/1
  # DELETE /roles_users/1.xml
  def destroy
    @roles_user = RolesUser.find(params[:id])
    @roles_user.destroy

    respond_to do |format|
      format.html { redirect_to(roles_users_url) }
      format.xml  { head :ok }
    end
  end
end

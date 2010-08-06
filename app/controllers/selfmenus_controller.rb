# -*- coding: utf-8 -*-
class SelfmenusController < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "Selfmenu",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'code', :width => 80, :editable => true},
                     { :field => 'name', :width => 80, :editable => true},
                     { :field => 'parent_id', :width => 80, :editable => true},
                     { :field => 'rec_type', :width => 80, :editable => true},
                     { :field => 'user_id', :width => 80, :editable => true},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = ''
    @sheet_fields_no_id = ":code, :name, :parent_id, :rec_type, :user_id, :remarks"
    @sheet_fields_no_id_params = ":code => params[:code], :name => params[:name], :parent_id => params[:parent_id], :rec_type => params[:rec_type], :user_id => params[:user_id], :remarks => params[:remarks]"
    @sheet_fields_type = "code:text_field name:text_field parent_id:text_field rec_type:text_field user_id:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      Selfmenu.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = Selfmenu.create(record_params)
      else
        record = Selfmenu.find(params[:id])
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

    records = Selfmenu.find(:all ) do |x|
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


  # GET /selfmenus/1
  # GET /selfmenus/1.xml
  def show
    @selfmenu = Selfmenu.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @selfmenu }
    end
  end

  # GET /selfmenus/new
  # GET /selfmenus/new.xml
  def new
    @selfmenu = Selfmenu.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @selfmenu }
    end
  end

  # GET /selfmenus/1/edit
  def edit
    @selfmenu = Selfmenu.find(params[:id])
  end

  # POST /selfmenus
  # POST /selfmenus.xml
  def create
    @selfmenu = Selfmenu.new(params[:selfmenu])

    respond_to do |format|
      if @selfmenu.save
        flash[:notice] = 'Selfmenu was successfully created.'
        format.html { redirect_to(@selfmenu) }
        format.xml  { render :xml => @selfmenu, :status => :created, :location => @selfmenu }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @selfmenu.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /selfmenus/1
  # PUT /selfmenus/1.xml
  def update
    @selfmenu = Selfmenu.find(params[:id])

    respond_to do |format|
      if @selfmenu.update_attributes(params[:selfmenu])
        flash[:notice] = 'Selfmenu was successfully updated.'
        format.html { redirect_to(@selfmenu) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @selfmenu.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /selfmenus/1
  # DELETE /selfmenus/1.xml
  def destroy
    @selfmenu = Selfmenu.find(params[:id])
    @selfmenu.destroy

    respond_to do |format|
      format.html { redirect_to(selfmenus_url) }
      format.xml  { head :ok }
    end
  end
end

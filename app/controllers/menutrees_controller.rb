# -*- coding: utf-8 -*-
class MenutreesController < ApplicationController
  before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "Menutree",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'code', :width => 80, :editable => true},
                     { :field => 'name', :width => 80, :editable => true},
                     { :field => 'parent_id', :width => 80, :editable => true, :edittype => "select",
                       :editoptions => { :value => get_records_format_data(Menutree, [:id,:code,:name])}},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = [{ :field => 'form_id', :width => 80, :editable => true},]
    @sheet_fields_no_id = ":code, :name, :parent_id, :remarks"
    @sheet_fields_no_id_params = ":code => params[:code], :name => params[:name], :parent_id => params[:parent_id], :remarks => params[:remarks]"
    @sheet_fields_type = "code:text_field name:text_field parent_id:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      Menutree.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = Menutree.create(record_params)
      else
        record = Menutree.find(params[:id])
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

    records = Menutree.find(:all ) do |x|
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


  # GET /menutrees/1
  # GET /menutrees/1.xml
  def show
    @menutree = Menutree.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @menutree }
    end
  end

  # GET /menutrees/new
  # GET /menutrees/new.xml
  def new
    @menutree = Menutree.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @menutree }
    end
  end

  # GET /menutrees/1/edit
  def edit
    @menutree = Menutree.find(params[:id])
  end

  # POST /menutrees
  # POST /menutrees.xml
  def create
    @menutree = Menutree.new(params[:menutree])

    respond_to do |format|
      if @menutree.save
        flash[:notice] = 'Menutree was successfully created.'
        format.html { redirect_to(@menutree) }
        format.xml  { render :xml => @menutree, :status => :created, :location => @menutree }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @menutree.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /menutrees/1
  # PUT /menutrees/1.xml
  def update
    @menutree = Menutree.find(params[:id])

    respond_to do |format|
      if @menutree.update_attributes(params[:menutree])
        flash[:notice] = 'Menutree was successfully updated.'
        format.html { redirect_to(@menutree) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @menutree.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /menutrees/1
  # DELETE /menutrees/1.xml
  def destroy
    @menutree = Menutree.find(params[:id])
    @menutree.destroy

    respond_to do |format|
      format.html { redirect_to(menutrees_url) }
      format.xml  { head :ok }
    end
  end
end

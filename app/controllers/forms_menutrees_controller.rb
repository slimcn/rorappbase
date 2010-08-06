# -*- coding: utf-8 -*-
class FormsMenutreesController < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "FormsMenutree",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'menutree_id', :width => 80, :editable => true},
                     { :field => 'form_id', :width => 80, :editable => true},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = ''
    @sheet_fields_no_id = ":menutree_id, :form_id, :remarks"
    @sheet_fields_no_id_params = ":menutree_id => params[:menutree_id], :form_id => params[:form_id], :remarks => params[:remarks]"
    @sheet_fields_type = "menutree_id:text_field form_id:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      FormsMenutree.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = FormsMenutree.create(record_params)
      else
        record = FormsMenutree.find(params[:id])
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

    records = FormsMenutree.find(:all ) do |x|
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


  # GET /forms_menutrees/1
  # GET /forms_menutrees/1.xml
  def show
    @forms_menutree = FormsMenutree.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @forms_menutree }
    end
  end

  # GET /forms_menutrees/new
  # GET /forms_menutrees/new.xml
  def new
    @forms_menutree = FormsMenutree.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @forms_menutree }
    end
  end

  # GET /forms_menutrees/1/edit
  def edit
    @forms_menutree = FormsMenutree.find(params[:id])
  end

  # POST /forms_menutrees
  # POST /forms_menutrees.xml
  def create
    @forms_menutree = FormsMenutree.new(params[:forms_menutree])

    respond_to do |format|
      if @forms_menutree.save
        flash[:notice] = 'FormsMenutree was successfully created.'
        format.html { redirect_to(@forms_menutree) }
        format.xml  { render :xml => @forms_menutree, :status => :created, :location => @forms_menutree }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forms_menutree.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forms_menutrees/1
  # PUT /forms_menutrees/1.xml
  def update
    @forms_menutree = FormsMenutree.find(params[:id])

    respond_to do |format|
      if @forms_menutree.update_attributes(params[:forms_menutree])
        flash[:notice] = 'FormsMenutree was successfully updated.'
        format.html { redirect_to(@forms_menutree) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forms_menutree.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forms_menutrees/1
  # DELETE /forms_menutrees/1.xml
  def destroy
    @forms_menutree = FormsMenutree.find(params[:id])
    @forms_menutree.destroy

    respond_to do |format|
      format.html { redirect_to(forms_menutrees_url) }
      format.xml  { head :ok }
    end
  end
end

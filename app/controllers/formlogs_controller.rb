# -*- coding: utf-8 -*-
class FormlogsController < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "formlog",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'form_id', :width => 80, :editable => true},
                     { :field => 'form_type', :width => 80, :editable => true},
                     { :field => 'status', :width => 80, :editable => true},
                     { :field => 'content', :width => 80, :editable => true},
                     { :field => 'auditflows_flownode_id', :width => 80, :editable => true},
                     { :field => 'employe_id', :width => 80, :editable => true},
                     { :field => 'user_id', :width => 80, :editable => true},
                     { :field => 'before_sequence_id', :width => 80, :editable => true},
                     { :field => 'after_sequence_id', :width => 80, :editable => true},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = ''
    @sheet_fields_no_id = ":form_id, :form_type, :status, :content, :auditflows_flownode_id, :employe_id, :user_id, :before_sequence_id, :after_sequence_id, :remarks"
    @sheet_fields_no_id_params = ":form_id => params[:form_id], :form_type => params[:form_type], :status => params[:status], :content => params[:content], :auditflows_flownode_id => params[:auditflows_flownode_id], :employe_id => params[:employe_id], :user_id => params[:user_id], :before_sequence_id => params[:before_sequence_id], :after_sequence_id => params[:after_sequence_id], :remarks => params[:remarks]"
    @sheet_fields_type = "form_id:text_field form_type:text_field status:text_field content:text_area auditflows_flownode_id:text_field employe_id:text_field user_id:text_field before_sequence_id:text_field after_sequence_id:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      Formlog.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = Formlog.create(record_params)
      else
        record = Formlog.find(params[:id])
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

    records = Formlog.find(:all ) do |x|
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


  # GET /formlogs/1
  # GET /formlogs/1.xml
  def show
    @formlog = Formlog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @formlog }
    end
  end

  # GET /formlogs/new
  # GET /formlogs/new.xml
  def new
    @formlog = Formlog.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @formlog }
    end
  end

  # GET /formlogs/1/edit
  def edit
    @formlog = Formlog.find(params[:id])
  end

  # POST /formlogs
  # POST /formlogs.xml
  def create
    @formlog = Formlog.new(params[:formlog])

    respond_to do |format|
      if @formlog.save
        flash[:notice] = 'Formlog was successfully created.'
        format.html { redirect_to(@formlog) }
        format.xml  { render :xml => @formlog, :status => :created, :location => @formlog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @formlog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /formlogs/1
  # PUT /formlogs/1.xml
  def update
    @formlog = Formlog.find(params[:id])

    respond_to do |format|
      if @formlog.update_attributes(params[:formlog])
        flash[:notice] = 'Formlog was successfully updated.'
        format.html { redirect_to(@formlog) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @formlog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /formlogs/1
  # DELETE /formlogs/1.xml
  def destroy
    @formlog = Formlog.find(params[:id])
    @formlog.destroy

    respond_to do |format|
      format.html { redirect_to(formlogs_url) }
      format.xml  { head :ok }
    end
  end
end

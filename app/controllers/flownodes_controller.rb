# -*- coding: utf-8 -*-
class FlownodesController < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "flownode",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'code', :width => 80, :editable => true},
                     { :field => 'name', :width => 80, :editable => true},
                     { :field => 'name_cn', :width => 80, :editable => true},
                     { :field => 'rec_type', :width => 80, :editable => true},
                     { :field => 'status', :width => 80, :editable => true},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = ''
    @sheet_fields_no_id = ":code, :name, :name_cn, :rec_type, :status, :remarks"
    @sheet_fields_no_id_params = ":code => params[:code], :name => params[:name], :name_cn => params[:name_cn], :rec_type => params[:rec_type], :status => params[:status], :remarks => params[:remarks]"
    @sheet_fields_type = "code:text_field name:text_field name_cn:text_field rec_type:text_field status:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      Flownode.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = Flownode.create(record_params)
      else
        record = Flownode.find(params[:id])
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

    records = Flownode.find(:all ) do |x|
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


  # GET /flownodes/1
  # GET /flownodes/1.xml
  def show
    @flownode = Flownode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @flownode }
    end
  end

  # GET /flownodes/new
  # GET /flownodes/new.xml
  def new
    @flownode = Flownode.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @flownode }
    end
  end

  # GET /flownodes/1/edit
  def edit
    @flownode = Flownode.find(params[:id])
  end

  # POST /flownodes
  # POST /flownodes.xml
  def create
    @flownode = Flownode.new(params[:flownode])

    respond_to do |format|
      if @flownode.save
        flash[:notice] = 'Flownode was successfully created.'
        format.html { redirect_to(@flownode) }
        format.xml  { render :xml => @flownode, :status => :created, :location => @flownode }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @flownode.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /flownodes/1
  # PUT /flownodes/1.xml
  def update
    @flownode = Flownode.find(params[:id])

    respond_to do |format|
      if @flownode.update_attributes(params[:flownode])
        flash[:notice] = 'Flownode was successfully updated.'
        format.html { redirect_to(@flownode) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @flownode.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /flownodes/1
  # DELETE /flownodes/1.xml
  def destroy
    @flownode = Flownode.find(params[:id])
    @flownode.destroy

    respond_to do |format|
      format.html { redirect_to(flownodes_url) }
      format.xml  { head :ok }
    end
  end
end

# -*- coding: utf-8 -*-
class CodeRulesController < ApplicationController
   before_filter :init_sheet

  def init_sheet
    @sheet_options = {'name' => "CodeRule",
                      "edit_form_type" => "multi_model"
                      }
    @sheet_fields = [{ :field => 'table_name', :width => 80, :editable => true},
                     { :field => 'field_name', :width => 80, :editable => true},
                     { :field => 'title', :width => 80, :editable => true},
                     { :field => 'seq', :width => 80, :editable => true},
                     { :field => 'seq_len', :width => 80, :editable => true},
                     { :field => 'step', :width => 80, :editable => true},
                     { :field => 'rule_type', :width => 80, :editable => true},
                     { :field => 'remarks', :width => 80, :editable => true}]
    @sheet_detail_fields = ''
    @sheet_fields_no_id = ":table_name, :field_name, :title, :seq, :seq_len, :step, :rule_type, :remarks"
    @sheet_fields_no_id_params = ":table_name => params[:table_name], :field_name => params[:field_name], :title => params[:title], :seq => params[:seq], :seq_len => params[:seq_len], :step => params[:step], :rule_type => params[:rule_type], :remarks => params[:remarks]"
    @sheet_fields_type = "table_name:text_field field_name:text_field title:text_field seq:text_field seq_len:text_field step:text_field rule_type:text_field remarks:text_area "
  end

  def post_data
    # It's of course your role to add security / validation here
    if params[:oper] == "del"
      CodeRule.find(params[:id]).destroy
    else
      @sheet_fields ||= { }
      record_params = { }
      @sheet_fields.each do |field|
        field_param = { field[:field].to_sym => params[field[:field].to_sym] }
        record_params[field[:field].to_sym] = params[field[:field].to_sym]
      end
      if params[:id] == "_empty"
        record = CodeRule.create(record_params)
      else
        record = CodeRule.find(params[:id])
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

    records = CodeRule.find(:all ) do |x|
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


  # GET /code_rules/1
  # GET /code_rules/1.xml
  def show
    @code_rule = CodeRule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @code_rule }
    end
  end

  # GET /code_rules/new
  # GET /code_rules/new.xml
  def new
    @code_rule = CodeRule.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @code_rule }
    end
  end

  # GET /code_rules/1/edit
  def edit
    @code_rule = CodeRule.find(params[:id])
  end

  # POST /code_rules
  # POST /code_rules.xml
  def create
    @code_rule = CodeRule.new(params[:code_rule])

    respond_to do |format|
      if @code_rule.save
        flash[:notice] = 'CodeRule was successfully created.'
        format.html { redirect_to(@code_rule) }
        format.xml  { render :xml => @code_rule, :status => :created, :location => @code_rule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @code_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /code_rules/1
  # PUT /code_rules/1.xml
  def update
    @code_rule = CodeRule.find(params[:id])

    respond_to do |format|
      if @code_rule.update_attributes(params[:code_rule])
        flash[:notice] = 'CodeRule was successfully updated.'
        format.html { redirect_to(@code_rule) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @code_rule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /code_rules/1
  # DELETE /code_rules/1.xml
  def destroy
    @code_rule = CodeRule.find(params[:id])
    @code_rule.destroy

    respond_to do |format|
      format.html { redirect_to(code_rules_url) }
      format.xml  { head :ok }
    end
  end
end

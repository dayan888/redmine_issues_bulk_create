# encoding: utf-8


class IssuesBulkCreateController < ApplicationController
  include Redmine::I18n
  unloadable
  before_filter :find_project, :authorize
  menu_item :issues_bulk_create
  
  layout 'issues_bulk_create'
  
  def index
    @msg = params[:notice]
    start_of_week
  end

  def create
    begin
      impl_id = 0
      rowidHash = {}
      Issue.transaction do
        params[:rowid].each_with_index {|rowid, i|
          puts rowid, params[:tracker][i], params[:subject][i], params[:description][i], params[:user][i], params[:start_date][i], params[:due_date][i]
          if rowid.split("-").length > 2
            parent = rowid[0..rowid.rindex("-")-1]
            parent_issue_id = rowidHash[parent] 
          else
            parent_issue_id = params[:parent_issue_id] unless Issue.find_by_id(params[:parent_issue_id]) == nil
          end
          issue_id = createIssue params[:tracker][i], params[:subject][i], params[:description][i], params[:user][i], params[:start_date][i], params[:due_date][i], parent_issue_id
          rowidHash[rowid] = issue_id
        } 
     
        @msg = l(:msg_registered)
      end
    
    rescue Exception => e
      logger.fatal e
      logger.fatal e.backtrace.join("\n")
      @msg = e.to_s
    end

    redirect_to :action => "index", :notice => @msg

  end

private
  def start_of_week
    @start_of_week = Setting.start_of_week
    @start_of_week = 1 if @start_of_week.blank?
    @start_of_week = @start_of_week.to_i % 7
  end


  def createIssue(tracker, subject, description, user, start, due, parent=nil, category=nil)
    print "#{tracker}, #{subject}, #{description}, #{user}, #{start}, #{due}, #{parent}, #{category} \n"
    
    i = Issue.new
    i.project_id = @project.id
    i.tracker_id = tracker
    i.subject = subject
    i.description = description
    i.assigned_to_id = user
    i.start_date = start
    i.due_date = due
    i.parent_issue_id = parent
    if category
      category_id =  IssueCategory.find_by_project_id_and_name(i.project_id, category)
      i.category_id = category_id if category_id
    end
    i.status_id = 1
#    i.priority_id = 2
    i.author_id = User.current.id
    i.save!(:validate => true)
    i.id
  end

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end 

end

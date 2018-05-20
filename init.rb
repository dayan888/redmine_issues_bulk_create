Redmine::Plugin.register :redmine_issues_bulk_create do
  name 'Bulk Create Issues plugin'
  author 'Dayan'
  description 'This is a plugin for Redmine'
  version '0.1.0'
  url ''
  author_url ''

  project_module :issues_bulk_create do
    permission :issues_bulk_create, :issues_bulk_create => [:index, :create]
  end
  menu :project_menu, :issues_bulk_create, { :controller => :issues_bulk_create, :action => :index }, :param => :project_id


end

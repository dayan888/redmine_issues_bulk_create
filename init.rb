Redmine::Plugin.register :redmine_issues_bulk_create do
  name 'Bulk Create Issues plugin'
  author 'Dayan'
  description 'This is a plugin for Redmine'
  version '0.1.0'
  url 'https://github.com/dayan888/redmine_issues_bulk_create'
  author_url 'https://github.com/dayan888'

  project_module :issues_bulk_create do
    permission :issues_bulk_create, :issues_bulk_create => [:index, :create]
  end
  menu :project_menu, :issues_bulk_create, { :controller => :issues_bulk_create, :action => :index }, :caption => :label_issues_bulk_create_menu, :param => :project_id


end

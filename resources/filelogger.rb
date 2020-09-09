resource_name :icinga2_filelogger
provides :icinga2_filelogger

property :cookbook, String, default: 'icinga2'
property :severity, String
property :path, String, required: true
action :create do
  new_resource.updated_by_last_action(object_template)
end
action :delete do
  new_resource.updated_by_last_action(object_template)
end

action_class do
  def object_template
    resource_name = new_resource.resource_name.to_s.gsub('icinga2_', '')
    ot = template ::File.join(node['icinga2']['objects_dir'], "#{resource_name}.conf") do
      source "object.#{resource_name}.conf.erb"
      cookbook 'icinga2'
      owner node['icinga2']['user']
      group node['icinga2']['group']
      mode '640'
      variables(object: new_resource.name,
                path: new_resource.path,
                severity: new_resource.severity)
      notifies platform?('windows') ? :restart : :reload, 'service[icinga2]'
    end
    ot.updated?
  end
end
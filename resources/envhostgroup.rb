resource_name :icinga2_envhostgroup if respond_to?(:resource_name)
provides :icinga2_envhostgroup
allowed_actions [:create, :delete, :nothing]

property :instance_name, String, name_property: true
property :cookbook, String, default: 'icinga2'
property :environment, String, default: name
property :zone, String
property :groups, Array

provides :icinga2_envhostgroup if respond_to?(:provides)

def whyrun_supported?
  true
end

action :create do
  new_resource.updated_by_last_action(object_template)
end

action :delete do
  new_resource.updated_by_last_action(object_template)
end



def object_template
  resource_name = new_resource.resource_name.to_s.gsub('icinga2_', '')

  template_file_name = new_resource.zone ? "#{resource_name}_#{new_resource.environment}_#{new_resource.zone}.conf" : "#{resource_name}_#{new_resource.environment}.conf"

  if new_resource.zone
    env_resources_path = ::File.join(node['icinga2']['zones_dir'], new_resource.zone, template_file_name)

    directory ::File.join(node['icinga2']['zones_dir'], new_resource.zone) do
      owner node['icinga2']['user']
      group node['icinga2']['group']
    end
  else
    env_resources_path = ::File.join(node['icinga2']['objects_dir'], template_file_name)
  end

  ot = template env_resources_path do
    source "object.#{resource_name}.conf.erb"
    cookbook 'icinga2'
    owner node['icinga2']['user']
    group node['icinga2']['group']
    mode 0o640
    variables(:environment => new_resource.environment, :groups => new_resource.groups)
    notifies platform?('windows') ? :restart : :reload, 'service[icinga2]'
  end
  ot.updated?
end


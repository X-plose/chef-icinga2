resource_name :icinga2_envendpoint
provides :icinga2_envendpoint if respond_to?(:provides)

property :instance_name, String, name_property: true
property :cookbook, String, default: 'icinga2'
property :environment, String, identity: true
property :zone, String
property :port, Integer, default: node['icinga2']['endpoint_port']
property :log_duration, String
property :endpoints, Array

action :create do
  new_resource.updated_by_last_action(object_template)
end

action :delete do
  new_resource.updated_by_last_action(object_template)
end

action_class do
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
      mode '640'
      variables(
        environment: new_resource.environment,
        endpoints: new_resource.endpoints,
        log_duration: new_resource.log_duration
      )
      notifies platform?('windows') ? :restart : :reload, 'service[icinga2]'
    end
    ot.updated?
  end
end
class Icinga2Usergroup < Chef::Resource
  resource_name :icinga2_usergroup
  provides :icinga2_usergroup
  allowed_actions [:create, :delete, :nothing]

  property :cookbook, String, default: 'icinga2'
  property :assign_where, Array
  property :display_name, String
  property :groups, Array
  property :zone, String
  property :ignore_where, Array
  property :template_support, FalseClass, default: false
  property :resource_properties, Array, default: %w(assign_where ignore_where display_name groups zone)

  def initialize(name, run_context = nil)
    super
    @provider = Chef::Provider::Icinga2Instance
    @name = name
  end
end

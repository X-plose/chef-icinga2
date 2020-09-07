resource_name :icinga2_applynotification
provides :icinga2_applynotification
allowed_actions [:create, :delete, :nothing]

property :cookbook, String, default: 'icinga2'

property :object_type, String, required: true
property :import, String
property :command, String
property :users, Array
property :user_groups, Array
property :times, Hash
property :interval, [String, Integer], regex: [ /^0|\d+[smhd]$/ ]
property :period, String
property :zone, String
property :types, Array
property :states, Array

property :assign_where, Array
property :ignore_where, Array

property :template_support, FalseClass, default: false
property :resource_properties, Array, default: %w(object_type import command users user_groups interval period types states times assign_where ignore_where zone)

# Example usage of paw_ansible_role_elasticsearch

# Simple include with default parameters
include paw_ansible_role_elasticsearch

# Or with custom parameters:
# class { 'paw_ansible_role_elasticsearch':
#   elasticsearch_version => '7.x',
#   ansible_managed => undef,
#   elasticsearch_network_host => 'localhost',
#   elasticsearch_http_port => 9200,
#   elasticsearch_extra_options => undef,
#   elasticsearch_heap_size_min => '1g',
#   elasticsearch_heap_size_max => '2g',
#   elasticsearch_package => 'elasticsearch',
#   elasticsearch_package_state => 'present',
#   elasticsearch_service_state => 'started',
#   elasticsearch_service_enabled => true,
# }

# paw_ansible_role_elasticsearch
# @summary Manage paw_ansible_role_elasticsearch configuration
#
# @param elasticsearch_version
# @param ansible_managed
# @param elasticsearch_network_host
# @param elasticsearch_http_port
# @param elasticsearch_extra_options
# @param elasticsearch_heap_size_min
# @param elasticsearch_heap_size_max
# @param elasticsearch_package
# @param elasticsearch_package_state
# @param elasticsearch_service_state
# @param elasticsearch_service_enabled
# @param par_tags An array of Ansible tags to execute (optional)
# @param par_skip_tags An array of Ansible tags to skip (optional)
# @param par_start_at_task The name of the task to start execution at (optional)
# @param par_limit Limit playbook execution to specific hosts (optional)
# @param par_verbose Enable verbose output from Ansible (optional)
# @param par_check_mode Run Ansible in check mode (dry-run) (optional)
# @param par_timeout Timeout in seconds for playbook execution (optional)
# @param par_user Remote user to use for Ansible connections (optional)
# @param par_env_vars Additional environment variables for ansible-playbook execution (optional)
# @param par_logoutput Control whether playbook output is displayed in Puppet logs (optional)
# @param par_exclusive Serialize playbook execution using a lock file (optional)
class paw_ansible_role_elasticsearch (
  String $elasticsearch_version = '7.x',
  Optional[String] $ansible_managed = undef,
  String $elasticsearch_network_host = 'localhost',
  Integer $elasticsearch_http_port = 9200,
  Optional[String] $elasticsearch_extra_options = undef,
  String $elasticsearch_heap_size_min = '1g',
  String $elasticsearch_heap_size_max = '2g',
  String $elasticsearch_package = 'elasticsearch',
  String $elasticsearch_package_state = 'present',
  String $elasticsearch_service_state = 'started',
  Boolean $elasticsearch_service_enabled = true,
  Optional[Array[String]] $par_tags = undef,
  Optional[Array[String]] $par_skip_tags = undef,
  Optional[String] $par_start_at_task = undef,
  Optional[String] $par_limit = undef,
  Optional[Boolean] $par_verbose = undef,
  Optional[Boolean] $par_check_mode = undef,
  Optional[Integer] $par_timeout = undef,
  Optional[String] $par_user = undef,
  Optional[Hash] $par_env_vars = undef,
  Optional[Boolean] $par_logoutput = undef,
  Optional[Boolean] $par_exclusive = undef
) {
# Execute the Ansible role using PAR (Puppet Ansible Runner)
  $vardir = $facts['puppet_vardir'] ? {
    undef   => $settings::vardir ? {
      undef   => '/opt/puppetlabs/puppet/cache',
      default => $settings::vardir,
    },
    default => $facts['puppet_vardir'],
  }
  $playbook_path = "${vardir}/lib/puppet_x/ansible_modules/ansible_role_elasticsearch/playbook.yml"

  par { 'paw_ansible_role_elasticsearch-main':
    ensure        => present,
    playbook      => $playbook_path,
    playbook_vars => {
      'elasticsearch_version'         => $elasticsearch_version,
      'ansible_managed'               => $ansible_managed,
      'elasticsearch_network_host'    => $elasticsearch_network_host,
      'elasticsearch_http_port'       => $elasticsearch_http_port,
      'elasticsearch_extra_options'   => $elasticsearch_extra_options,
      'elasticsearch_heap_size_min'   => $elasticsearch_heap_size_min,
      'elasticsearch_heap_size_max'   => $elasticsearch_heap_size_max,
      'elasticsearch_package'         => $elasticsearch_package,
      'elasticsearch_package_state'   => $elasticsearch_package_state,
      'elasticsearch_service_state'   => $elasticsearch_service_state,
      'elasticsearch_service_enabled' => $elasticsearch_service_enabled,
    },
    tags          => $par_tags,
    skip_tags     => $par_skip_tags,
    start_at_task => $par_start_at_task,
    limit         => $par_limit,
    verbose       => $par_verbose,
    check_mode    => $par_check_mode,
    timeout       => $par_timeout,
    user          => $par_user,
    env_vars      => $par_env_vars,
    logoutput     => $par_logoutput,
    exclusive     => $par_exclusive,
  }
}

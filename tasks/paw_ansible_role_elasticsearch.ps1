# Puppet task for executing Ansible role: ansible_role_elasticsearch
# This script runs the entire role via ansible-playbook

$ErrorActionPreference = 'Stop'

# Determine the ansible modules directory
if ($env:PT__installdir) {
  $AnsibleDir = Join-Path $env:PT__installdir "lib\puppet_x\ansible_modules\ansible_role_elasticsearch"
} else {
  # Fallback to Puppet cache directory
  $AnsibleDir = "C:\ProgramData\PuppetLabs\puppet\cache\lib\puppet_x\ansible_modules\ansible_role_elasticsearch"
}

# Check if ansible-playbook is available
$AnsiblePlaybook = Get-Command ansible-playbook -ErrorAction SilentlyContinue
if (-not $AnsiblePlaybook) {
  $result = @{
    _error = @{
      msg = "ansible-playbook command not found. Please install Ansible."
      kind = "puppet-ansible-converter/ansible-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Check if the role directory exists
if (-not (Test-Path $AnsibleDir)) {
  $result = @{
    _error = @{
      msg = "Ansible role directory not found: $AnsibleDir"
      kind = "puppet-ansible-converter/role-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Detect playbook location (collection vs standalone)
# Collections: ansible_modules/collection_name/roles/role_name/playbook.yml
# Standalone: ansible_modules/role_name/playbook.yml
$CollectionPlaybook = Join-Path $AnsibleDir "roles\paw_ansible_role_elasticsearch\playbook.yml"
$StandalonePlaybook = Join-Path $AnsibleDir "playbook.yml"

if ((Test-Path (Join-Path $AnsibleDir "roles")) -and (Test-Path $CollectionPlaybook)) {
  # Collection structure
  $PlaybookPath = $CollectionPlaybook
  $PlaybookDir = Join-Path $AnsibleDir "roles\paw_ansible_role_elasticsearch"
} elseif (Test-Path $StandalonePlaybook) {
  # Standalone role structure
  $PlaybookPath = $StandalonePlaybook
  $PlaybookDir = $AnsibleDir
} else {
  $result = @{
    _error = @{
      msg = "playbook.yml not found in $AnsibleDir or $AnsibleDir\roles\paw_ansible_role_elasticsearch"
      kind = "puppet-ansible-converter/playbook-not-found"
    }
  }
  Write-Output ($result | ConvertTo-Json)
  exit 1
}

# Build extra-vars from PT_* environment variables
$ExtraVars = @{}
if ($env:PT_elasticsearch_version) {
  $ExtraVars['elasticsearch_version'] = $env:PT_elasticsearch_version
}
if ($env:PT_ansible_managed) {
  $ExtraVars['ansible_managed'] = $env:PT_ansible_managed
}
if ($env:PT_elasticsearch_network_host) {
  $ExtraVars['elasticsearch_network_host'] = $env:PT_elasticsearch_network_host
}
if ($env:PT_elasticsearch_http_port) {
  $ExtraVars['elasticsearch_http_port'] = $env:PT_elasticsearch_http_port
}
if ($env:PT_elasticsearch_extra_options) {
  $ExtraVars['elasticsearch_extra_options'] = $env:PT_elasticsearch_extra_options
}
if ($env:PT_elasticsearch_heap_size_min) {
  $ExtraVars['elasticsearch_heap_size_min'] = $env:PT_elasticsearch_heap_size_min
}
if ($env:PT_elasticsearch_heap_size_max) {
  $ExtraVars['elasticsearch_heap_size_max'] = $env:PT_elasticsearch_heap_size_max
}
if ($env:PT_elasticsearch_package) {
  $ExtraVars['elasticsearch_package'] = $env:PT_elasticsearch_package
}
if ($env:PT_elasticsearch_package_state) {
  $ExtraVars['elasticsearch_package_state'] = $env:PT_elasticsearch_package_state
}
if ($env:PT_elasticsearch_service_state) {
  $ExtraVars['elasticsearch_service_state'] = $env:PT_elasticsearch_service_state
}
if ($env:PT_elasticsearch_service_enabled) {
  $ExtraVars['elasticsearch_service_enabled'] = $env:PT_elasticsearch_service_enabled
}

$ExtraVarsJson = $ExtraVars | ConvertTo-Json -Compress

# Execute ansible-playbook with the role
Push-Location $PlaybookDir
try {
  ansible-playbook playbook.yml `
    --extra-vars $ExtraVarsJson `
    --connection=local `
    --inventory=localhost, `
    2>&1 | Write-Output
  
  $ExitCode = $LASTEXITCODE
  
  if ($ExitCode -eq 0) {
    $result = @{
      status = "success"
      role = "ansible_role_elasticsearch"
    }
  } else {
    $result = @{
      status = "failed"
      role = "ansible_role_elasticsearch"
      exit_code = $ExitCode
    }
  }
  
  Write-Output ($result | ConvertTo-Json)
  exit $ExitCode
}
finally {
  Pop-Location
}

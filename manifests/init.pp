# == Class: totpcgi
#
# Manages totp-cgi server and client.
#
# === Parameters
#
# [*configuration*]
#   Hash that defines the configuration for totpcgi.
#   This will get written to /etc/totpcgi/totpcgi.yaml so the hash
#   will be converted to YAML
#
#   *Type*: hash
#
#   *default*: none - this is a required parameter
#
# === Variables
#
# [*group*]
#   The group that totpcgi should operate as
#
#   *Type*: string
#
#   *default*: totpcgi
#
# [*user*]
#   The user that totpcgi should operate as
#
#   *Type*: string
#
#   *default*: totpcgi
#
# [*user_home*]
#   The home directory for the totpcgi user
#
#   *Type*: string (absolute path)
#
#   *default*: /home/totpcgi
#
# [*venv_path*]
#   Fully qualified path to the virtualenv that totpcgi should be
#   installed into. The virtualenv is not managed by this module. It is
#   recommend that a module such as stankevich/python be used to manage
#   in a virtualenv
#
#   *Type*: string (absolute path)
#
#   *default*: /opt/venv-totpcgi
#
# [*vcs_path*]
#   Fully qualified path to the vcs repo that totpcgi will be checked
#   out into. totpcgi will utilize the virtualenv to execute a pip
#   install out of this vcsrepo
#
#   *Type*: string (absolute path)
#
#   *default*: /opt/vcs-totpcgi
#
# [*vcs_source*]
#   vcsrepo source path for totpcgi.
#
#   *Type*: string (vcsrepo URL)
#
#   *default*: GitHub totpcgi repo from OpenStack
#
# [*vcs_type*]
#   vcsrepo requires a type to be passed to it
#
#   *Type*: string
#
#   *default*: git
#
# [*vcs_revision*]
#   Revision to pass to the vcsrepo configuration
#
#   *Type*: string
#
#   *default*: undef (aka use latest HEAD)
#
# === Examples
#
# === Authors
#
# Clint Savage <herlo@linuxfoundation.org>
#
# === Copyright
#
# Copyright 2015 Clint Savage
#
# === License
#
# @License Apache-2.0 <http://spdx.org/licenses/Apache-2.0>
#
class totpcgi (
  $install_totpcgi                  = $totpcgi::params::install_totpcgi,
  $install_qrcode                   = $totpcgi::params::install_pincode,
  $require_pincode                  = $totpcgi::params::require_pincode,
  $success_string                   = $totpcgi::params::success_string,
  $encrypt_secret                   = $totpcgi::params::encrypt_secret,
  $window_size                      = $totpcgi::params::window_size,
  $rate_limit                       = $totpcgi::params::rate_limit,
  $scratch_tokens_n                 = $totpcgi::params::scratch_tokens_n,
  $bits                             = $totpcgi::params::bits,
  $totp_user_mask                   = $totpcgi::params::totp_user_mask,
  $action_url                       = $totpcgi::params::action_url,
  $css_root                         = $totpcgi::params::css_root,
  $templates_dir                    = $totpcgi::params::templates_dir,
  $trust_http_auth                  = $totpcgi::params::trust_http_auth,
  $secret::engine                   = $totpcgi::params::secret::engine,
  $secret::secrets_dir              = $totpcgi::params::secret::secrets_dir,
  $secret::pg_connect_string        = $totpcgi::params::secret::pg_connect_string,
  $secret::mysql_connect_host       = $totpcgi::params::secret::mysql_connect_host,
  $secret::mysql_connect_user       = $totpcgi::params::secret::mysql_connect_user,
  $secret::mysql_connect_password   = $totpcgi::params::secret::mysql_connect_password,
  $secret::mysql_connect_db         = $totpcgi::params::secret::mysql_connect_db,
  $secret::ldap_url                 = $totpcgi::params::secret::ldap_url,
  $secret::ldap_dn                  = $totpcgi::params::secret::ldap_dn,
  $secret::ldap_cacert              = $totpcgi::params::secret::ldap_cacert,
  $pincode::engine                  = $totpcgi::params::pincode::engine,
  $pincode::usehash                 = $totpcgi::params::pincode::usehash,
  $pincode::makedb                  = $totpcgi::params::pincode::makedb,
  $pincode::pincode_file            = $totpcgi::params::pincode::pincode_file,
  $pincode::pg_connect_string       = $totpcgi::params::pincode::pg_connect_string,
  $pincode::mysql_connect_host      = $totpcgi::params::pincode::mysql_connect_host,
  $pincode::mysql_connect_user      = $totpcgi::params::pincode::mysql_connect_user,
  $pincode::mysql_connect_password  = $totpcgi::params::pincode::mysql_connect_password,
  $pincode::mysql_connect_db        = $totpcgi::params::pincode::mysql_connect_db,
  $pincode::ldap_url                = $totpcgi::params::pincode::ldap_url,
  $pincode::ldap_dn                 = $totpcgi::params::pincode::ldap_dn,
  $pincode::ldap_cacert             = $totpcgi::params::pincode::ldap_cacert,
  $state::engine                    = $totpcgi::params::state::engine,
  $state::pg_connect_string         = $totpcgi::params::state::pg_connect_string,
  $state::mysql_connect_host        = $totpcgi::params::state::mysql_connect_host,
  $state::mysql_connect_user        = $totpcgi::params::state::mysql_connect_user,
  $state::mysql_connect_password    = $totpcgi::params::state::mysql_connect_password,
  $state::mysql_connect_db          = $totpcgi::params::state::mysql_connect_db,
  $state::ldap_url                  = $totpcgi::params::state::ldap_url,
  $state::ldap_dn                   = $totpcgi::params::state::ldap_dn,
  $state::ldap_cacert               = $totpcgi::params::state::ldap_cacert,
) inherits totpcgi::params {
  # Make sure that all the params are properly formatted
  validate_absolute_path($secrets_dir)
  validate_string($secret::engine)

  anchor { 'totpcgi::begin': }
  anchor { 'totpcgi::end': }

  include totpcgi::config
  include totpcgi::service

  Anchor['totpcgi::begin'] ->
    Class['totpcgi::install'] ->
    Class['totpcgi::config'] ->
#    Class['totpcgi::service'] ->
  Anchor['totpcgi::end']
}
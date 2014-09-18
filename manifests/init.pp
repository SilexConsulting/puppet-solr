# == Class: solr
#
# Full description of class solr here.
#
# === Parameters
#
# [*source_dir*]
#   If defined, the whole solr configuration directory content is retrieved recursively from
#   the specified source (parameter: source => $source_dir , recurse => true)
#
# [*source_dir_purge*]
#   If set to true all the existing configuration directory is overriden by the
#   content retrived from source_dir. (source => $source_dir , recurse => true , purge => true)
#
class solr (
  $source_dir = 'UNSET',
  $source_dir_purge   = false,
) inherits solr::params {

  $config = $source_dir ? {
    'UNSET'   => $solr::params::config,
    default   => $source_dir,
  }

  class { 'solr::install': } ->
  class { 'solr::config':
    config => $config,
    source_dir_purge => $source_dir_purge,
  } ~>
  Service[$solr::params::tomcat_service] ->
  Class['solr', 'tomcat']
}

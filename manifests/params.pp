# == Class solr::params
#
# This class is meant to be called from solr
# It sets variables according to platform
#
class solr::params {
  require tomcat

  $tomcat_service   = $tomcat::service_name
  $tomcat_version   = $tomcat::version
  $tomcat_user      = "tomcat${tomcat::version}"
  $tomcat_group     = "tomcat${tomcat::version}"

  $solr_home        = '/usr/share/solr'
  $solr_conf_dir    = '/etc/solr'
  $solr_version     = '4.6.0'
  $download_site    = 'http://archive.apache.org/dist/lucene/solr/'

  $file_name        = "solr-${solr_version}.tgz"
  $tomcat_home      = "/usr/share/tomcat${tomcat_version}"
  $tomcat_basedir   = "/var/lib/tomcat${tomcat_version}"

  $config           = 'puppet:///modules/solr/'

  case $::osfamily {
    'Debian', 'RedHat': {
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}

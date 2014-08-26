# == Class solr::params
#
# This class is meant to be called from solr
# It sets variables according to platform
#
class solr::params {
  $tomcat_version = 6
  $tomcat_home                        = "/usr/share/tomcat${tomcat_version}"
  $tomcat_basedir                     = "/var/lib/tomcat${tomcat_version}"
  $tomcat_user                        = "tomcat"
  $tomcat_group                       = "tomcat"

  $solr_home                          = '/usr/share/solr'
  $solr_conf_dir                      = '/etc/solr'
  $solr_version                       = '4.6.0'
  $service_name                       = "tomcat${tomcat_version}"

  $config                             = 'puppet:///modules/solr/'
  case $::osfamily {
    'Debian': {
    }
    'RedHat': {
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}

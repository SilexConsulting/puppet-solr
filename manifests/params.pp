# == Class solr::params
#
# This class is meant to be called from solr
# It sets variables according to platform
#
class solr::params {
  case $::osfamily {
    'Debian': {
      $tomcat_home                        = '/usr/share/tomcat7'
      $tomcat_basedir                     = '/var/lib/tomcat7'
      $tomcat_user                        = 'tomcat7'
      $tomcat_group                       = 'tomcat7'

      $solr_home                          = '/usr/share/solr'
      $solr_conf_dir                      = '/etc/solr'
      $solr_version                       = '4.6.0'
      $service_name                       = 'tomcat7'

      $config                             = 'puppet:///modules/solr/'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}

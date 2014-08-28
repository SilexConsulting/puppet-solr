# == Class solr::install
#
class solr::install {
  include solr::params

  package { 'wget':
    ensure  => present,
  }

  package { 'curl':
    ensure  => present,
  }

}

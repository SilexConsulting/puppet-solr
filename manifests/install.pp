# == Class solr::install
#
class solr::install {
  include solr::params

  package { 'default-jdk':
    ensure  => present,
  }

  package { 'wget':
    ensure  => present,
  }

  package { 'curl':
    ensure  => present,
  }

}

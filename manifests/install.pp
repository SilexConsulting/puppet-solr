# == Class solr::install
#
class solr::install {
  include solr::params
  include beluga::wget
}

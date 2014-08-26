# == Class: solr::config
# This class is meant to be called from solr
# Download, install and configure solr
#
class solr::config(
  $config,
  $source_dir_purge,
) {
  include solr::params

  $tomcat_home              = $::solr::params::tomcat_home
  $tomcat_basedir           = $::solr::params::tomcat_basedir
  $tomcat_user              = $::solr::params::tomcat_user
  $tomcat_group             = $::solr::params::tomcat_group
  $tomcat_version           = $::solr::params::tomcat_version
  $solr_home                = $::solr::params::solr_home
  $solr_conf_dir            = $::solr::params::solr_conf_dir
  $solr_version             = $::solr::params::solr_version
  $file_name                = "solr-${solr_version}.tgz"
  $download_site            = 'http://archive.apache.org/dist/lucene/solr/'

  # Copy configuration
  file { $solr::solr_conf_dir:
    ensure    => directory,
    source    => $config,
    recurse   => true,
    purge     => $source_dir_purge,
    owner     => $tomcat_user,
    group     => $tomcat_group,
    require   => Package["tomcat${solr::params::tomcat_version}"],
  }

  # Create the solr home directories
  file { $solr_home:
    ensure    => directory,
    owner     => $tomcat_user,
    group     => $tomcat_group,
    mode      => '0755',
    require   => File[$solr::solr_conf_dir],
  } ->

  # Symlink solr cores directory into the solr home folder
  file { "${solr_home}/cores":
    ensure    => 'link',
    target    => "${solr::solr_conf_dir}/cores",
    owner     => $tomcat_user,
    group     => $tomcat_group,
  } ->

  # Symlink solr.xml into the solr home folder
  file { "${solr_home}/solr.xml":
    ensure    => 'link',
    target    => "${solr::solr_conf_dir}/solr.xml",
    owner     => $tomcat_user,
    group     => $tomcat_group,
  }


  # Copy the solr context file for tomcat
  file {"/etc/tomcat${solr::params::tomcat_version}/Catalina/localhost/solr.xml":
    ensure    => 'present',
    content   => template('solr/solr_context.erb'),
    require   => Package["tomcat${solr::params::tomcat_version}"],
  }

  file {"${solr::tomcat_basedir}/webapps":
    ensure    => directory,
    owner     => $tomcat_user,
    group     => $tomcat_group,
    require   => Package["tomcat${solr::params::tomcat_version}"],
  }

  # download solr source to  /tmp:
  exec { 'solr-download':
    command   => "wget ${download_site}/${solr_version}/${file_name}",
    cwd       => '/tmp',
    creates   => "/tmp/${file_name}",
    onlyif    => "test ! -d ${solr_home}/WEB-INF && test ! -f /tmp/${file_name}",
    timeout   => 0,
    require   => File["${solr::tomcat_basedir}/webapps"],
  }

  exec { 'solr-extract':
    path      => ['/usr/bin', '/usr/sbin', '/bin'],
    command   => "tar xzvf ${file_name}",
    cwd       => "/tmp",
    onlyif    => "test -f /tmp/${file_name} && test ! -d /tmp/solr-${solr_version}",
    require   => Exec['solr-download'],
  }

  exec { 'solr-install-logging-jars':
    path      => ['/usr/bin', '/usr/sbin', '/bin'],
    cwd       => "/tmp",
    command   => "jar xvf /tmp/solr-${solr_version}/dist/solr-${solr_version}.war; cp /tmp/solr-${solr_version}/example/lib/ext/*.jar ${solr::tomcat_home}/lib",
    onlyif    => "test ! -f ${solr::tomcat_home}/lib/log4j-1.2.16.jar",
    require   => Exec['solr-extract'],
  }


  # copy dis, contrib and the solr.war from the downloaded solr archive.
  file { "${solr::solr_home}/dist":
    ensure    => directory,
    recurse   => true,
    purge     => true,
    owner     => $tomcat_user,
    group     => $tomcat_group,
    source    => "/tmp/solr-${solr_version}/dist",
    require   =>  Exec['solr-extract'],
  }

  file { "${solr::solr_home}/contrib":
    ensure    => directory,
    recurse   => true,
    purge     => true,
    owner     => $tomcat_user,
    group     => $tomcat_group,
    source    => "/tmp/solr-${solr_version}/contrib",
    require   =>  Exec['solr-extract'],
  }

  file { "${solr::solr_home}/solr.war":
      ensure    => present,
      owner     => $tomcat_user,
      group     => $tomcat_group,
      source    => "/tmp/solr-${solr_version}/dist/solr-${solr_version}.war",
      require   =>  Exec['solr-extract'],
    }

  # Create the solr data directories
  file { '/var/lib/solr':
    ensure    => directory,
    owner     => $tomcat_user,
    group     => $tomcat_group,
    mode      => '0755',
    require   => Package["tomcat${solr::params::tomcat_version}"],
  }

}

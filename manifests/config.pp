# == Class: solr::config
# This class is meant to be called from solr
# Download, install and configure solr
#
class solr::config(
  $config,
  $source_dir_purge,
) {
  include solr::params
  require beluga::wget
  require tomcat::install

  # Copy configuration
  file { $solr::params::solr_conf_dir:
    ensure    => directory,
    source    => $config,
    recurse   => true,
    purge     => $source_dir_purge,
    force     => $source_dir_purge,
    owner     => $solr::params::tomcat_user,
    group     => $solr::params::tomcat_group,
  }

  # Create the solr home directories
  file { $solr::params::solr_home:
    ensure    => directory,
    owner     => $solr::params::tomcat_user,
    group     => $solr::params::tomcat_group,
    mode      => '0755',
    require   => File[$solr::params::solr_conf_dir],
  }

  # Symlink solr cores directory into the solr home folder
  file { "${solr::params::solr_home}/cores":
    ensure    => 'link',
    target    => "${solr::solr_conf_dir}/cores",
    owner     => $solr::params::tomcat_user,
    group     => $solr::params::tomcat_group,
    require   => File[$solr::params::solr_home],
  } ->
  file { "${solr::params::solr_home}/solr.xml":
    ensure    => 'link',
    target    => "${solr::params::solr_conf_dir}/solr.xml",
    owner     => $solr::params::tomcat_user,
    group     => $solr::params::tomcat_group,
    require   => File[$solr::params::solr_home],
  }

  # Copy the solr context file for tomcat
  file {"/etc/tomcat${solr::params::tomcat_version}/Catalina/localhost/solr.xml":
    ensure    => 'present',
    content   => template('solr/solr_context.erb'),
  }

  file {$solr::params::tomcat_basedir:
    ensure    => directory,
    owner     => $solr::params::tomcat_user,
    group     => $solr::params::tomcat_group,
  }
  file {"${solr::params::tomcat_basedir}/webapps":
    ensure    => directory,
    owner     => $solr::params::tomcat_user,
    group     => $solr::params::tomcat_group,
  }

  # download solr source to  /tmp:
  exec { 'solr-download':
    command   => "wget ${solr::params::download_site}/${solr::params::solr_version}/${solr::params::file_name}",
    cwd       => '/tmp',
    creates   => "/tmp/${solr::params::file_name}",
    onlyif    => "test ! -d ${solr_home}/WEB-INF && test ! -f /tmp/${solr::params::file_name}",
    timeout   => 0,
    require   => File["${solr::params::tomcat_basedir}/webapps"],
  }

  exec { 'solr-extract':
    path      => ['/usr/bin', '/usr/sbin', '/bin'],
    command   => "tar xzvf ${solr::params::file_name}",
    cwd       => "/tmp",
    onlyif    => "test -f /tmp/${solr::params::file_name} && test ! -d /tmp/solr-${solr::params::solr_version}",
    require   => Exec['solr-download'],
  }

  exec { 'solr-install-logging-jars':
    path      => ['/usr/bin', '/usr/sbin', '/bin'],
    cwd       => "/tmp",
    command   => "jar xvf /tmp/solr-${solr::params::solr_version}/dist/solr-${solr::params::solr_version}.war; cp /tmp/solr-${solr::params::solr_version}/example/lib/ext/*.jar ${solr::params::tomcat_home}/lib",
    onlyif    => "test ! -f ${solr::params::tomcat_home}/lib/log4j-1.2.16.jar",
    require   => Exec['solr-extract'],
  }


  # copy dis, contrib and the solr.war from the downloaded solr archive.
  file { "${solr::params::solr_home}/dist":
    ensure    => directory,
    recurse   => true,
    purge     => true,
    owner     => $solr::params::tomcat_user,
    group     => $solr::params::tomcat_group,
    source    => "/tmp/solr-${solr::params::solr_version}/dist",
    require   =>  Exec['solr-extract'],
  }

  file { "${solr::params::solr_home}/contrib":
    ensure    => directory,
    recurse   => true,
    purge     => true,
    force     => true,
    owner     => $solr::params::tomcat_user,
    group     => $solr::params::tomcat_group,
    source    => "/tmp/solr-${solr::params::solr_version}/contrib",
    require   =>  Exec['solr-extract'],
  }

  file { "${solr::params::solr_home}/solr.war":
      ensure    => present,
      owner     => $solr::params::tomcat_user,
      group     => $solr::params::tomcat_group,
      source    => "/tmp/solr-${solr::params::solr_version}/dist/solr-${solr::params::solr_version}.war",
      require   =>  Exec['solr-extract'],
    }

  # Create the solr data directories
  file { '/var/lib/solr':
    ensure    => directory,
    owner     => $solr::params::tomcat_user,
    group     => $solr::params::tomcat_group,
    mode      => '0755',
  }

}

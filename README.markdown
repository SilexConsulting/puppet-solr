#solr

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with Solr](#setup)
    * [What Solr affects](#what-Solr-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with Solr](#beginning-with-Solr)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module installs Solr from Apache distributions into Tomcat 7 and configures it with either a custom configuration or
the example configuration distributed with the binaries.

##Module Description


##Setup

###What Solr affects

####Installs
* /user/share/solr
* /etc/tomcat7/Catalina/localhost/solr.xml - Tomcat context file
* /etc/solr/ - Solr configuration files
* /var/lib/solr/data - Solr data folder

If you supply your own Solr configuration, you should ensure that you have a core.properties file which uses an absolute
path to a folder under the solr data directory /var/lib/solr/data.

###Setup Requirements **OPTIONAL**

You need to have a working installation of tomcat 7. You can use https://github.com/SilexConsulting/puppet-tomcat
  
###Beginning with Solr  

 To install solr with the default configuration, you only need to include the module


 """include solr"""


##Usage


 If you would like to include your own solr configuration, you can specifiy it as follows:

 class { 'solr':
    source_dir => "puppet:///modules/my_solr/",
  }

##Reference


##Limitations

Works with debian based distributions and installs Solr version 4.6.0

##Development

Contributions welcomed,

##Release Notes/Contributors/Etc

see changelog

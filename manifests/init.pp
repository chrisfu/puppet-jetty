##
# = Class: jetty
#
# == Parameters:
#
# $root:: The root path of the installation, default is /opt
# $base:: The JETTY_BASE web deployment
# $version:: The version of the jetty server
# $service_ensure:: Offers the opportinity to manage the service
# $manage_user:: Offers the opportunity to manage the group and user
# $user:: The name of the user
# $group:: The name of the group
# $mirror:: The mirror base URL
# $archive_type:: ('.zip', '.tar.gz')
# $checksum_type:: ('sha1', 'md5')
# $jetty_arguments:: A list of additional arguments for the jetty process
# $java:: The java command to launch jetty server
# $java_options:: Additional options to the JVM
# $configuration:: A hash to configure sereval modules of the jetty server
# logconfig:: A hash to configure log4j logging system
#
# == Requires:
#
# Java
#
# == Sample Usage:
#
# class { 'jetty':
#   version => '9.2.21.v20170120',
# }
#
#
# == Authors
#
# Javier Juarez
#
# == Copyright
#
# This software is distributed under Apache 2.0 license
#
class jetty(
  Stdlib::Absolutepath      $root,
  Stdlib::Absolutepath      $base,
  String                    $version,
  Optional[String]          $service_name,
  Enum['running', 'stopped'] $service_ensure,
  Boolean                   $manage_user,
  String                    $user,
  String                    $group,
  Stdlib::Httpurl           $mirror,
  Enum['tar.gz', 'zip']     $archive_type,
  Enum['sha1', 'md5']       $checksum_type,
  Optional[String]          $jetty_arguments,
  Optional[String]          $java,
  Optional[String]          $java_options,
  Optional[Hash]            $configuration,
  Optional[Hash]            $logconfig,
  ) {

  contain jetty::install
  contain jetty::config
  contain jetty::service

  Class['::jetty::install']
  -> Class['::jetty::config']
  ~> Class['::jetty::service']
}


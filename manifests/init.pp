#
# == Class: gpm
#
# Manages the gpm mouse server.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-gpm Puppet module.
# Copyright 2010-2019 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class gpm (
        Boolean                                      $enable,
        Variant[Boolean, Enum['running', 'stopped']] $ensure,
        Array[String[1], 1]                          $packages,
        String[1]                                    $service,
    ) {

    package { $packages:
        ensure => installed,
        notify => Service[$service],
    }

    -> file {
        default:
            owner   => 'root',
            group   => 'root',
            mode    => '0640',
            seluser => 'system_u',
            selrole => 'object_r',
            seltype => 'etc_t',
            notify  => Service[$service],
            ;
        # Legacy configuration file that's no longer relevant.
        '/etc/sysconfig/mouse':
            ensure  => absent,
            ;
    }

    -> service { $service:
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => true,
        hasstatus  => true,
    }

}

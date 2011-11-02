# modules/gpm/manifests/init.pp

class gpm {

    package { "gpm":
	ensure	=> installed,
    }

    file { "/etc/sysconfig/mouse":
        # don't forget to verify these!
        group	=> "root",
        mode    => "0640",
        owner   => "root",
        require => Package["gpm"],
        seluser => "system_u",
        selrole => "object_r",
        seltype => "etc_t",
        source  => "puppet:///modules/gpm/mouse",
    }

    service { "gpm":
        enable		=> true,
        ensure		=> running,
        hasrestart	=> true,
        hasstatus	=> true,
        require		=> [
            Package["gpm"],
        ],
        subscribe	=> [
            File["/etc/sysconfig/mouse"],
        ],
    }

}

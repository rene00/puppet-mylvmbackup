class mylvmbackup {
    package { 'mylvmbackup':
        ensure => installed,
    }
}

define mylvmbackup::config (
    database_user = undef,
    database_password = undef,
    vgname = 'vgdb0',
    lvname = 'lvmysqldb',
    lvsize = '5G',
    log_method = 'console',
    mountdir = '/var/cache/mylvmbackup/mnt',
    backupdir = '/var/cache/mylvmbackup/backup',
    relpath = '',
    tarsuffixarg = '',
    xfs = '0'
) {
    if $database_user == undef {
        $mysql_database_user = hiera('mylvmbackup_database_user')
    } else {
        $mysql_database_user = $database_user
    }

    if $database_password == undef {
        $mysql_database_password = hiera('mylvmbackup_database_password')
    } else {
        $mysql_database_password = $database_password
    }

    file { '/etc/mylvmbackup.conf':
        owner => root,
        group => root,
        mode => 0400,
        content => template('mylvmbackup/mylvmbackup_conf.erb'),
        require => Package['mylvmbackup']
    }

    file { [ '/var/cache/mylvmbackup/mnt', 
            '/var/cache/mylvmbackup', 
            '/var/cache', 
            '/var/cache/mylvmbackup/backup' ]:
        owner => root,
        group => root,
        mode => 0755,
        ensure => directory,
    }
}

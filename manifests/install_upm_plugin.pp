
define atlassian_plugins::install_upm_plugin(
    $plugin_key,
    $marketplace_user,
    $marketplace_pass,
    $plugin_version      = 'latest',
    $instance_admin_user = undef,
    $instance_admin_pass = undef,
    $application_url     = undef,
    $license             = undef,
    $custom_commands     = [],
    $guard_file_path     = "/etc/puppet/${name}"
){
    exec { "install_plugin_${name}":
        command => "bash --login -c 'atlassian_plugin_installer \"${instance_admin_user}\" \"${instance_admin_pass}\" \"${application_url}\" \"${plugin_key}\" \"${plugin_version}\" \"${marketplace_user}\" \"${marketplace_pass}\" \"${license}\"'",
        unless  => ["test -f ${guard_file_path}"],
        require => Package['atlassian_plugin_installer']
    }

    $previous_require = Exec["install_plugin_${name}"]
    $custom_commands.each |Integer $index, String $custom_command| {
        exec { $custom_command:
            command => $custom_command,
            unless  => ['test -f ${guard_file_path}'],
            require => $previous_require
        }
        $previous_require = Exec[$custom_command]
    }

    file {$guard_file_path:
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => $previous_require,
    }
}
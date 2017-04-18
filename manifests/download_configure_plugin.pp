# Params:
#
#
define atlassian_plugins::download_configure_plugin(
    $download_url        = undef,
    $download_user       = undef,
    $download_pass       = undef,
    $downloaded_filename = undef,
    $download_folder     = '/tmp',
    $user                = 'root',
    $group               = 'root',
    $download_command    = 'curl',
    $custom_commands     = [],
){

    if ($downloaded_filename) {
        $real_file_name = $downloaded_filename
    }else {
        $tarball_url_splitted = split($download_url, '/')
        $real_file_name = $tarball_url_splitted[-1]
    }
    if ($download_user and $download_pass) {
        $credentials = "-u ${download_user}:${download_pass}"
    } else {
        $credentials = ''
    }

    $download_output_param = "-o ${real_file_name}"

    exec { "download_${real_file_name}":
            command => "${download_command} ${download_output_param} ${credentials} ${download_url}",
            cwd     => $download_folder,
            unless  => ["test -f ${real_file_name}"],
            timeout => 3600
    } -> exec { "change_ownership_${real_file_name}":
            command => "chown ${user}:${group} ${download_folder}/${real_file_name}",
    }

    $previous_require = Exec["download_${real_file_name}"]
    $custom_commands.each |Integer $index, String $custom_command| {
        exec { $custom_command:
            command => $custom_command,
            onlyif  => ["test -f ${real_file_name}"],
            require => $previous_require
        }
        $previous_require = Exec[$custom_command]
    }
}
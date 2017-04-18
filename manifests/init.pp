# Installs and configures atlassian plugins
#
# Params
#
# atlassian_plugins - hash of atlassian plugins to download
# 
# hiera example: 
# atlassian_plugins::atlassian_plugins:
#     'json-layout.jar': 
#         download_url: 'url'
#         download_user: 'username'
#         download_pass: 'password'
#         download_folder: '/opt/jira/install/atlassian-jira/WEB-INF/lib'
#         user: 'jira'
#         group: 'jira'
#         custom_commands:
#             - "sed -ie 's/filelog$/filelog, jsonlog/g' /opt/jira/install/atlassian-jira/WEB-INF/classes/log4j.properties"
#             - "sed -ie 's/filelog,/filelog, jsonlog,/g' /opt/jira/install/atlassian-jira/WEB-INF/classes/log4j.properties"

class atlassian_plugins(
    $atlassian_plugins        = {},
    $upm_plugins              = {},
    $require_class            = undef,
    $restart_instance_command = undef,
    $package_source_repo      = 'https://rubygems.org',
){
    if ($require_class){
        Class[$require_class] -> Atlassian_plugins::Download_configure_plugin<| |>
        Class[$require_class] -> Atlassian_plugins::Install_upm_plugin<| |>
    }
    create_resources('atlassian_plugins::download_configure_plugin', $atlassian_plugins)
    if (!empty($upm_plugins)){
        if ( !defined(Package['atlassian_plugin_installer']) ) {
            package {
                'atlassian_plugin_installer':
                    ensure   => installed,
                    provider => gem,
                    source   => $package_source_repo,
            }
        }
        create_resources('atlassian_plugins::install_upm_plugin', $upm_plugins)
    }
    if (str2bool($restart_instance_command)){
        Atlassian_plugins::Install_upm_plugin<| |> -> Exec[$restart_instance_command]
        Atlassian_plugins::Download_configure_plugin<| |> -> Exec[$restart_instance_command]
        exec { $restart_instance_command:
            command     => $restart_instance_command
        }
    }
}

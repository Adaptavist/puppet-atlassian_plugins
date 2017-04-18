# Atlassian plugin download and configuration

Params

atlassian_plugins - hash of atlassian plugins to download
require_class - plugins requires the defined class

## hiera example:

    atlassian_plugins::require_class: 'avstapp'
    atlassian_plugins::restart_instance_command: 'service jira restart'
    atlassian_plugins::atlassian_plugin:
        'json-layout.jar': 
            download_url: 'url'
            download_user: 'username'
            download_pass: 'password'
            download_folder: '/opt/jira/install/atlassian-jira/WEB-INF/lib'
            user: 'jira'
            group: 'jira'
            custom_commands:
                - "sed -ie 's/filelog$/filelog, jsonlog/g' /opt/jira/install/atlassian-jira/WEB-INF/classes/log4j.properties"
                - "sed -ie 's/filelog,/filelog, jsonlog,/g' /opt/jira/install/atlassian-jira/WEB-INF/classes/log4j.properties"


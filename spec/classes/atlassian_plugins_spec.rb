require 'spec_helper'
 

describe 'atlassian_plugins', :type => 'class' do

  atlas_plugins = {
  	'some-downloadable.jar' => { 
       'download_url' => 'www.example.com/some-downloadable.jar',
       'download_user' => 'username',
       'download_pass' => 'password',
       'download_folder' => '/opt/jira/install/atlassian-jira/WEB-INF/lib',
       'user' => 'jira',
       'group' => 'jira',
    }
  }

  upm_plugins = {
  	'some-marketplace-plugin' => { 
      'plugin_key' => 'blah',
      'marketplace_user' => 'username',
      'marketplace_pass' => 'password',	
    }
  }

  context "Should install one downloadable plugin but no UPM plugins" do
    let(:params) {{
      :atlassian_plugins => atlas_plugins,
      :upm_plugins => {},
    }}

    it { 
      is_expected.to have_atlassian_plugins__download_configure_plugin_resource_count(1)
      is_expected.to contain_atlassian_plugins__download_configure_plugin('some-downloadable.jar') 
    }

    it { is_expected.to have_atlassian_plugins__install_upm_plugin_resource_count(0) }

  end


  context "Should install one downloadable plugin and one UPM plugin" do
    let(:params) {{
      :atlassian_plugins => atlas_plugins,
      :upm_plugins => upm_plugins,
    }}

    it { 
      is_expected.to have_atlassian_plugins__download_configure_plugin_resource_count(1)
      is_expected.to contain_atlassian_plugins__download_configure_plugin('some-downloadable.jar') 
    }

    it { 
      is_expected.to have_atlassian_plugins__install_upm_plugin_resource_count(1)
      is_expected.to contain_atlassian_plugins__install_upm_plugin('some-marketplace-plugin')
    }

  end

end
  


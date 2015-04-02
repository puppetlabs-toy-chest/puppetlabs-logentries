require "open-uri"
require "net/http"
require "fileutils"
require "uri"
require "json"


Puppet::Type.type(:logentries_token).provide :token do
  desc "Logentries token provider"

  def create
    p "creating"
    url = URI('https://api.logentries.com')
    params = {
      "request"   => "new_log",
      "user_key"  => resource[:account_key],
      "host_key"  => le_host_id,
      "source"    => "token",
      "name"      => resource[:name],
      "retention" => -1,
    }
    rsp = Net::HTTP.post_form(url,
                              params)
    rsp_json = JSON.parse(rsp.body)
    new_key = rsp_json['log']['token']
    p rsp_json
    FileUtils::mkdir_p '/etc/logentries'
    open('/etc/logentries/%s' % resource[:env_var], 'a') do |f|
      f.puts "#{new_key}"
    end
  end

  def le_host_id
    key_val = %x(le whoami | grep key)
    key_val.strip!.split('=')[1].strip!
  end

  def destroy
    raise 'Error: Destroy/Uninstall not implemented yet'
  end

  def env_var
    if resource[:env_var] and resource[:env_var] != :name
      resource[:env_var]
    else
      "le_#{resource[:name]}"
    end
  end

  def exists?
    filename = '/etc/logentries/%s' % resource[:env_var]
    File.exist? filename
  end
end

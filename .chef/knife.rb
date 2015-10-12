# See http://docs.chef.io/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
knife[:editor] = '"C:\Program Files (x86)\Notepad++\notepad++.exe" -nosession -multiInst'
log_level                :info
log_location             STDOUT
node_name                "jebaile7964"
client_key               "#{current_dir}/jebaile7964.pem"
validation_client_name   "magiccityit-validator"
validation_key           "#{current_dir}/magiccityit-validator.pem"
chef_server_url          "https://api.chef.io/organizations/magiccityit"
cookbook_path            ["#{current_dir}/../cookbooks"]
ssl_verify_mode			 :verify_none
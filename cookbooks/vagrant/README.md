# vagrant Cookbook

Installs Vagrant 1.6+ and manages vagrant plugins w/ a custom resource. If you are not familiar with Vagrant, read about it here:

* Vagrant: http://www.vagrantup.com/

This cookbook is not intended to be used for vagrant "1.0" (gem install) versions. A recipe is provided for removing the gem, see __Recipes__.

This cookbook is not supported for installing versions of Vagrant older than 1.6.

# Requirements

**This cookbook should not be used on platforms that Vagrant itself does not support.**

## Vagrant Supported Platforms

Vagrant does not specifically list supported platforms on the project web site. However, the only platforms with [packages provided](https://www.vagrantup.com/downloads.html) are:

* Mac OS X
* Windows
* Linux (deb-package based platforms, e.g., Debian and Ubuntu)
* Linux (rpm-packaged based platforms, e.g., RHEL and CentOS)

Other platforms are not supported. This cookbook attempts to exit gracefully in places where unsupported platforms may cause an issue, but it is **strongly recommended** that this cookbook not be on an unsupported platform's node run list or used as a dependency for cookbooks used on unsupported platforms.

## Tested with Test Kitchen

* Debian 7.6
* Ubuntu 14.04
* CentOS 6.5
* OS X 10.9

May work on other Debian/RHEL family distributions with or without modification.

Support exists for Windows but this has not yet been added to test-kitchen. OS X support is in test-kitchen, but requires a custom box be created.

The URL and Checksum attributes must be set, see __Attributes__

Because Vagrant is installed as a native system package, Chef must run as a privileged user (e.g., root).

# Attributes

The following attributes *must* be set. The cookbook has helper methods in `libraries` that attempt to automatically discover these values.

* `node['vagrant']['version']` - Version of Vagrant to use, default is 1.6.5, which was current at the time of writing.
* `node['vagrant']['url']` - URL to the Vagrant installation package.
* `node['vagrant']['checksum']` - SHA256 checksum of the Vagrant
  installation package.

**Note**: I'm not taking pull requests to merely update the version. Change it in your local setup via role, environment, wrapper cookbook, etc. The helpers should take care of the rest. If a new version of vagrant requires other changes, then open an issue.

If the node is Windows, the MSI version must be set. This is used by
the `windows_package` resource to determine if the package is
installed.

* `node['vagrant']['msi_version']` - Version string of the installed
  MSI "package" on Windows.

The following attributes are optional.

* `node['vagrant']['plugins']` - A array of plugins. The elements in
  the array can be a string or a hash. String elements should be the
  names of plugins to install. Hash elements should have two keys,
  "name" and "version", for the plugin name and its version to
  install. This is used by the `vagrant_plugin` resource in the
  `install_plugins` recipe.
* `node['vagrant']['user']` - A user that is used to automatically install plugins as for the `node['vagrant']['plugins']` attribute.

# Resources

This cookbook includes the `vagrant_plugin` resource, for managing
vagrant plugins.

## vagrant_plugin

### Actions

- `:install`: installs the specified plugin. Default.
- `:uninstall`: uninstalls the specified plugin
- `:remove`: uninstalls the specified plugin

### Attribute Parameters

- `:plugin_name`: name attribute, the name of the plugin, e.g.
  "vagrant-omnibus".
- `:version`: version of the plugin to installed, must be specified as
  a string, e.g., "1.0.2"
- `:user`: a user to run plugin installation as. Usually this is for single user systems (like workstations).
- `:sources`: alternate locations to search for plugins. This would commonly
  be used if you are hosting your vagrant plugins in a custom gem repo

### Examples

    vagrant_plugin "vagrant-omnibus"

    vagrant_plugin "vagrant-berkshelf"
      version "1.2.0"
      sources ["http://src1.example.com", "http://src2.example.com"]
    end

    # Install the plugins as the `donuts` user, into ~donuts/.vagrant.d
    vagrant_plugin "vagrant-aws"
      user "donuts"
    end

# Recipes

## default

The default recipe includes the platform-family specific recipe to
install Vagrant. If the `node['vagrant']['plugins']` attribute is not empty, it includes the install_plugins recipe to install any required vagrant plugins.

## install_plugins

Iterates over the `node['vagrant']['plugins']` attribute and installs the listed plugins. If that attribute is a hash, it uses the version. If the `node['vagrant']['user']` attribute is set, the plugins are installed for only that user.

## debian, fedora, mac_os_x, rhel, windows

These are the platform family recipes included by the default recipe.
The `fedora` recipe will include `rhel`.

## uninstall_gem

This recipe will attempt to uninstall the `vagrant` gem with the
`gem_package` and `chef_gem` resources. Meaning, it will use the `gem`
binary in the `PATH` of the shell executing Chef to uninstall, and
then use Chef's built-in RubyGems to uninstall. If you have a
customized Ruby environment, such as with rbenv or rvm (or other), you
may need to manually remove and clean up anything leftover, such as
running `rbenv rehash`. Likewise, if you have multiple copies of the
vagrant gem installed, you'll need to clean up all versions. This
recipe won't support such craziness :-).

# Usage

Set the url and checksum attributes on the node. Do this in a role, or
a "wrapper" cookbook. Or, just set the version and let the magic happen.

Then include the default recipe on the node's run list.

To specify plugins for installation in the default recipe, specify an
array for the `node['vagrant']['plugins']` attribute. For example, to
install the `vagrant-omnibus` plugin (any version) and version "1.2.0"
of the `vagrant-berkshelf` plugin:

    node.set['vagrant']['plugins'] = [
      "vagrant-omnibus",
      {"name" => "vagrant-berkshelf", "version" => "1.2.0"}
    ]

See the attribute description above.

# License and Authors

* Author:: Joshua Timberman <opensource@housepub.org>
* Copyright (c) 2013-2014, Joshua Timberman

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

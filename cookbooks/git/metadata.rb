name		'git'
maintainer 	'github'
maintainer_email 'git@github.com'
%w{ dmg build-essential yum windows }.each do |cookbook|
	depends cookbook
end

depends 'runit','>= 1.0'

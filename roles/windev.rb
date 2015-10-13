name 		'windev'
description 	'for Windows Developer Machines'
run_list(
	'recipe[git]',
	'recipe[powershell]',
	'recipe[putty]',
	'recipe[7-zip]',
	'recipe[notepadplusplus_2]',
	'recipe[chrome]',
	'recipe[virtualbox]',
	'recipe[chocolatey]',
	'recipe[vagrant]'
)
default_attributes(

)

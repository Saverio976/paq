module paq

import os

pub fn uninstall_paq(mut config Config, package_name string) ! {
	package := config.installed[package_name] or {
		return error('Package not installed')
	}
	install_dir := os.join_path(package.install_dir, package_name)
	println('Uninstalling ${package.repo_name}/${package.package_name}...')
	package_paq := Paq.new(install_dir)!
	package_paq.uninstall(package.bin_dir)
	config.uninstall(package_name)
	config.save()!
}

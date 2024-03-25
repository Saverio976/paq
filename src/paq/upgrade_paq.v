module paq

pub fn upgrade_paq(mut config Config) ! {
	for package in config.installed.values() {
		uninstall_paq(mut config, package.package_name) or {
			eprintln('Failed to uninstall package: ${package.repo_name}/${package.package_name}: ${err}')
		}
		install_paq(mut config, package.repo_name, package.package_name) or {
			eprintln('Failed to install package: ${package.repo_name}/${package.package_name}: ${err}')
			continue
		}
	}
}

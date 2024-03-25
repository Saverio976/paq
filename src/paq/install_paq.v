module paq

import arrays

pub fn install_paq(mut config Config, repo_name string, package_name string) ! {
	mut found := false
	for mut repo in config.repos {
		repo.resolve_name() or { continue }
		if repo.name != repo_name {
			continue
		}
		packages := repo.list_packages()!
		package := arrays.find_first(packages, fn [package_name] (elem PaqUnresolved) bool {
			return elem.name == package_name
		}) or { return error('package ${package_name} not found') }
		println('Downloading ${repo_name}/${package_name}...')
		dir := package.install(config.install_dir)!
		println('Installing ${repo_name}/${package_name}...')
		package_paq := Paq.new(dir)!
		package_paq.install(config.bin_dir) or {
			package_paq.uninstall(config.bin_dir)
			return error('failed to install ${package_name}: ${err}')
		}
		println('Saving to locks ${repo_name}/${package_name}...')
		config.install(repo_name, package_name)
		config.save() or {
			package_paq.uninstall(config.bin_dir)
			return error('failed to install ${package_name}: ${err}')
		}
		found = true
	}
	if !found {
		return error('repo ${repo_name} not found')
	}
}

module paq

import arrays

pub fn install_paq(mut config Config, repo_name string, package_name string, is_dep bool) ! {
	mut found := false
	if config.repos.len == 0 {
		eprintln('No list of package added. If you want the defaults one, please run `paq config add-repo "https://github.com/Saverio976/paq/releases/latest/download/paq-packages.toml"`')
	}
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
		for dep in package_paq.deps {
			splited := dep.split('/')
			if splited.len != 2 {
				continue
			}
			mut config_cpy := config
			config_cpy.set_install_dir(dir) or {
				package_paq.uninstall(config.bin_dir)
				return error('failed to install deps ${splited[0]}/${splited[1]} for ${repo_name}/${package_name}: ${err}')
			}
			install_paq(mut config_cpy, splited[0], splited[1], true) or {
				package_paq.uninstall(config.bin_dir)
				return error('failed to install deps ${splited[0]}/${splited[1]} for ${repo_name}/${package_name}: ${err}')
			}
		}
		if !is_dep {
			println('Saving to locks ${repo_name}/${package_name}...')
			config.install(repo_name, package_name)
			config.save() or {
				package_paq.uninstall(config.bin_dir)
				return error('failed to install ${package_name}: ${err}')
			}
		}
		found = true
	}
	if !found {
		return error('repo ${repo_name} not found')
	}
}

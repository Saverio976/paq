module paq

import os
import toml

struct ConfigToml {
	repos       []string
	bin_dir     string
	install_dir string
}

struct PaqInstalled {
	bin_dir string
	install_dir string
	repo_name string
mut:
	package_name string
}

struct PaqInstalledsLockToml {
	packages map[string]PaqInstalled
}

@[noinit]
pub struct Config {
	config_file string
	lock_file string
mut:
	repos       []Repo
	bin_dir     string
	install_dir string
	installed   map[string]PaqInstalled
}

pub fn (mut config Config) set_install_dir(install_dir string) ! {
	if !os.is_dir(install_dir) {
		os.mkdir_all(install_dir)!
	}
	config.install_dir = install_dir
}

pub fn (mut config Config) set_bin_dir(bin_dir string) ! {
    if !os.is_dir(bin_dir) {
        os.mkdir_all(bin_dir)!
    }
    config.bin_dir = bin_dir
}

pub fn (mut config Config) add_repo(repo_url string) ! {
	for repo_installed in config.repos {
		if repo_installed.url_packages == repo_url {
			return error('Repo ${repo_url} already added.')
		}
	}
	println('Creating repo ${repo_url}...')
	mut repo := Repo.new(repo_url)
	println('Downloading packages list...')
	repo.update_file_cached()!
	println('Getting repo name...')
	repo.resolve_name()!
	println('Listing packages available for [${repo.name}](${repo_url})')
	repo.list_packages()!
	println('Adding repo ${repo.name} to available repos')
	config.repos << repo
}

fn get_default_bin_dir() !string {
	home_local_bin := os.join_path(os.home_dir(), '.local', 'bin')
	if os.is_dir(home_local_bin) && os.is_writable(home_local_bin) {
		return home_local_bin
	}
	home_bin := os.join_path(os.home_dir(), 'bin')
	if os.is_dir(home_bin) && os.is_writable(home_bin) {
		return home_bin
	}
	home_paq_bin := os.join_path(os.home_dir(), '.local', 'bin')
	if !os.is_dir(home_paq_bin) {
		os.mkdir_all(home_paq_bin)!
		eprintln('Please add "${home_paq_bin}" to your PATH')
		return home_paq_bin
	}
	return error('Could not find a writable bin directory')
}

fn get_default_install_dir() !string {
	mut install_dir := ''
	if data_dir := os.getenv_opt('XDG_DATA_HOME') {
		install_dir = os.join_path(data_dir, 'paq')
	} else {
		install_dir = os.join_path(os.home_dir(), '.paq')
	}
	if !os.is_dir(install_dir) {
		os.mkdir_all(install_dir)!
	}
	return install_dir
}

pub fn (config Config) save() ! {
	config_toml := ConfigToml{config.repos.map(fn (repo Repo) string {
		return repo.url_packages
	}), config.bin_dir, config.install_dir}
	os.write_file(config.config_file, toml.encode[ConfigToml](config_toml))!
	pack_installed_locks := PaqInstalledsLockToml{config.installed}
	os.write_file(config.lock_file, toml.encode[PaqInstalledsLockToml](pack_installed_locks))!
}

pub fn Config.new() !Config {
	config_folder := os.config_dir() or { os.join_path(os.home_dir(), '.config') }
	config_file := os.join_path(config_folder, 'paq', 'paq.toml')
	lock_file := os.join_path(config_folder, 'paq', 'lock.toml')
	dirname := os.dir(config_file)
	if !os.is_dir(dirname) {
		os.mkdir_all(dirname)!
	}
	if !os.is_file(config_file) {
		config := Config{config_file, lock_file, [], get_default_bin_dir()!, get_default_install_dir()!, map[string]PaqInstalled{}}
		config.save()!
	}
	config_toml := toml.decode[ConfigToml](os.read_file(config_file)!)!
	mut config := Config{config_file, lock_file, config_toml.repos.map(fn (url string) Repo {
		return Repo.new(url)
	}), config_toml.bin_dir, config_toml.install_dir, map[string]PaqInstalled{}}
	if !os.is_file(lock_file) {
		config.save()!
	}
	doc := toml.parse_file(lock_file)!
	for key, value in doc.value('packages').as_map() {
		mut package := value.reflect[PaqInstalled]()
		package.package_name = key
		config.installed[key] = package
	}
	return config
}

pub fn (mut config Config) install(repo_name string, package_name string) {
	config.installed[package_name] = PaqInstalled{config.bin_dir, config.install_dir, repo_name, package_name}
}

pub fn (mut config Config) uninstall(repo_name string) {
	config.installed.delete(repo_name)
}

module paq

import os
import crypto.md5
import net.http
import toml
import time
import v.pref
import compress.szip

struct PaqUnresolved {
pub:
	version      string
	download_url string
	content_type string
	checksum     string
pub mut:
	name         string
}

struct Repo {
	path_cached string
mut:
	packages []PaqUnresolved
pub:
	url_packages string
pub mut:
	name string
}

pub fn Repo.new(url_packages string) Repo {
	cache_sufix := md5.hexhash(url_packages) + '_${pref.get_host_os()}_${pref.get_host_arch()}_' +
		time.now().ddmmy()
	return Repo{
		path_cached: os.join_path(os.cache_dir(), 'paq', 'paq-packages-${cache_sufix}.toml')
		url_packages: url_packages
	}
}

pub fn (mut repo Repo) update_file_cached() ! {
	dirname := os.dir(repo.path_cached)
	if !os.is_dir(dirname) {
		os.mkdir_all(dirname)!
	}
	http.download_file(repo.url_packages, repo.path_cached)!
	repo.name = ''
	repo.packages.clear()
}

pub fn (mut repo Repo) resolve_name() ! {
	if !os.is_file(repo.path_cached) {
		repo.update_file_cached()!
	}
	doc := toml.parse_file(repo.path_cached)!
	repo.name = doc.value('name').string()
}

pub fn (mut repo Repo) list_packages() ![]PaqUnresolved {
	if repo.packages.len != 0 {
		return repo.packages
	}
	if !os.is_file(repo.path_cached) {
		repo.update_file_cached()!
	}
	doc := toml.parse_file(repo.path_cached)!
	for key, value in doc.value('packages').as_map() {
		mut package := value.reflect[PaqUnresolved]()
		package.name = key
		repo.packages << package
	}
	return repo.packages
}

fn (package PaqUnresolved) install(install_dir string) !string {
	tmp_dir_zip := os.join_path(os.vtmp_dir(), '${package.name}-${package.version}.zip')
	target_dowload_zip := os.join_path(install_dir, package.name)
	http.download_file(package.download_url, tmp_dir_zip)!
	if !os.is_dir(target_dowload_zip) {
		os.mkdir_all(target_dowload_zip)!
	}
	if !szip.extract_zip_to_dir(tmp_dir_zip, target_dowload_zip)! {
		return error('Failed to extract zip for ${package.name} ${package.version}')
	}
	return target_dowload_zip
}

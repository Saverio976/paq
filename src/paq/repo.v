module paq

import os
import crypto.md5
import net.http
import toml

struct PaqUnresolved {
pub:
	name         string
	version      string
	download_url string
	content_type string
	checksum     string
}

struct Repo {
	path_cached string
mut:
	packages []PaqUnresolved
pub:
	url_packages string
}

pub fn Repo.new(url_packages string) Repo {
	return Repo{
		path_cached: os.join_path(os.cache_dir(), 'paq', 'paq-packages-${md5.hexhash(url_packages)}.toml')
		url_packages: url_packages
	}
}

pub fn (mut repo Repo) list_packages() ![]PaqUnresolved {
	if repo.packages.len != 0 {
		return repo.packages
	}
	if !os.is_file(repo.path_cached) {
		dirname := os.dir(repo.path_cached)
		if !os.is_dir(dirname) {
			os.mkdir_all(dirname)!
		}
		http.download_file(repo.url_packages, repo.path_cached)!
	}
	doc := toml.parse_file(repo.path_cached)!
	for value in doc.value('packages').as_map().values() {
		package := value.reflect[PaqUnresolved]()
		repo.packages << package
	}
	return repo.packages
}

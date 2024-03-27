module paq

import strings

@[noinit]
pub struct SearchPaqResult {
pub:
	name string
	version string
	repo string
}

pub fn SearchPaqResult.new(name string, version string, repo_name string) SearchPaqResult {
	return SearchPaqResult{
		name: name
		version: version
		repo: repo_name
	}
}

pub fn search_paq(mut config Config, search_name string) ![]SearchPaqResult {
	mut packages_matched := []SearchPaqResult{}
	for mut repo in config.repos {
		repo.resolve_name()!
		all_packages := repo.list_packages()!
		packages := all_packages.filter(fn [search_name] (elem PaqUnresolved) bool {
			if search_name.len > 1 && elem.name.contains(search_name) {
				return true
			}
			return strings.levenshtein_distance(elem.name, search_name) < (search_name.len / 2)
		})
		packages_matched << packages.map(fn [repo] (elem PaqUnresolved) SearchPaqResult {
			return SearchPaqResult{elem.name, elem.version, repo.name}
		})
	}
	return packages_matched
}

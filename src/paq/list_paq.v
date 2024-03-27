module paq

import strings
import os

@[noinit]
pub struct ListPaqResult {
pub:
	install_config PaqInstalled
	paq Paq
}

pub fn ListPaqResult.new(install_config PaqInstalled) ListPaqResult {
	package := Paq.new(os.join_path(install_config.install_dir, install_config.package_name)) or {
		Paq{}
	}
	return ListPaqResult{install_config, package}
}

pub fn list_paq(mut config Config, search_name string) ![]ListPaqResult {
	packages := config.installed.values().filter(fn [search_name] (elem PaqInstalled) bool {
		if search_name == '' {
			return true
		}
		if search_name.len > 1 && elem.package_name.contains(search_name) {
			return true
		}
		return strings.levenshtein_distance(elem.package_name, search_name) < (search_name.len / 2)
	})
	packages_matched := packages.map(fn (elem PaqInstalled) ListPaqResult {
		return ListPaqResult.new(elem)
	})
	return packages_matched
}

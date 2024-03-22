module paq

import os
import toml

struct Chmod {
pub:
	path string
	mode string
}

struct Paq {
mut:
	install_dir string
pub:
	author      string
	description string
	homepage    string
	license     string
	binaries    []string
	version     string
	name        string
	deps        []string
pub mut:
	chmod_resolved []Chmod
}

pub fn Paq.new(install_paq_dir string) !Paq {
	file_string := os.read_file(os.join_path(install_paq_dir, 'metadata.toml'))!
	mut package := toml.decode[Paq](file_string)!
	package.install_dir = install_paq_dir
	doc := toml.parse_text(file_string)!
	mut i := 0
	for {
		if key_path := doc.value_opt('chmod[${i}].path') {
			if key_mode := doc.value_opt('chmod[${i}].mode') {
				package.chmod_resolved << Chmod{key_path.string(), key_mode.string()}
			} else {
				break
			}
		} else {
			break
		}
		i = i + 1
	}
	return package
}

pub fn (package Paq) uninstall(bin_dir string) {
	for binary in package.binaries {
		file_path := os.join_path(bin_dir, binary)
		os.rm(file_path) or { eprintln('Cannot remove ${file_path}: ${err}') }
	}
	os.rmdir_all(package.install_dir) or {
		eprintln('Cannot remove ${package.install_dir}: ${err}')
	}
}

module main

import paq

fn main() {
	package := paq.Paq.new('path to something')!
	println('${package.name}')
	for config_mode in package.chmod_resolved {
		println('${config_mode.path}: ${config_mode.mode}')
	}
}

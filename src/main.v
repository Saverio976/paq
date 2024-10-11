module main

import paq
import os
import cli

const flag_bypass_paq_recurse = 'utra_secure_you_know'

fn get_config() !paq.Config {
	return paq.Config.new()!
}

fn install(cmd cli.Command) ! {
	if cmd.args[1] == 'paq' && (cmd.args.len == 2 || cmd.args[2] != flag_bypass_paq_recurse) {
		println('Installing Paq: First Step...')
		target_cpy := os.join_path(os.temp_dir(), 'paq-binary')
		target_cpy_dir := os.dir(target_cpy)
		if !os.is_dir(target_cpy) {
			os.mkdir_all(target_cpy_dir)!
		}
		if os.is_file(target_cpy) {
			os.rm(target_cpy)!
		}
		println('Copying ${os.executable()} to ${target_cpy}')
		os.cp(os.executable(), target_cpy)!
		println('Chmod 755 of ${target_cpy}')
		os.chmod(target_cpy, 0o755) or { return error('Cannot chmod ${target_cpy} to 755') }
		println('Installing Paq: Last Step...')
		os.execvp(target_cpy, ['install', cmd.args[0], cmd.args[1], flag_bypass_paq_recurse])!
	}
	mut config := get_config()!
	paq.install_paq(mut config, cmd.args[0], cmd.args[1], false)!
}

fn uninstall(cmd cli.Command) ! {
	mut config := get_config()!
	paq.uninstall_paq(mut config, cmd.args[0])!
}

fn update(cmd cli.Command) ! {
	mut config := get_config()!
	paq.update_repos(mut config)!
}

fn upgrade(cmd cli.Command) ! {
	mut config := get_config()!
	paq.upgrade_paq(mut config, false)!
}

fn search(cmd cli.Command) ! {
	mut config := get_config()!
	search_term := if cmd.args.len == 1 { cmd.args[0] } else { '' }
	packages := paq.search_paq(mut config, search_term)!
	for package in packages {
		println('${package.repo}/${package.name} :: ${package.version}')
	}
}

fn list(cmd cli.Command) ! {
	mut config := get_config()!
	search_term := if cmd.args.len == 1 { cmd.args[0] } else { '' }
	packages := paq.list_paq(mut config, search_term)!
	for package in packages {
		println('')
		println('#')
		println('[${package.install_config.package_name}]')
		println('repo = "${package.install_config.repo_name}"')
		println('author = "${package.paq.author}"')
		println('version = "${package.paq.version}"')
		println('description = "${package.paq.description}"')
		println('homepage = "${package.paq.homepage}"')
		println('license = "${package.paq.license}"')
		println('binaries = [')
		for binary in package.paq.binaries {
			println('    "${binary}",')
		}
		println(']')
		println('deps = [')
		for dep in package.paq.deps {
			println('    "${dep}",')
		}
		println(']')
		println('bin_dir = "${package.install_config.bin_dir}"')
		println('install_dir = "${package.paq.install_dir}"')
	}
}

fn config_set_bin_dir(cmd cli.Command) ! {
	mut config := get_config()!
	paq.set_config_bin_dir(mut config, cmd.args[0])!
}

fn config_set_install_dir(cmd cli.Command) ! {
	mut config := get_config()!
	paq.set_config_install_dir(mut config, cmd.args[0])!
}

fn config_add_repo(cmd cli.Command) ! {
	mut config := get_config()!
	paq.add_config_repo(mut config, cmd.args[0])!
}

fn main() {
	mut app := cli.Command{
		name: 'paq'
		description: 'WIP side project package manager\nList of packages (repos) can be added with `paq config`'
		execute: fn (cmd cli.Command) ! {
			cmd.execute_help()
		}
		version: '0.4.0'
		commands: [
			cli.Command{
				name: 'install'
				description: 'install a package from a repo'
				required_args: 2
				usage: '<repo> <package>'
				execute: install
			},
			cli.Command{
				name: 'uninstall'
				description: 'uninstall a package'
				required_args: 1
				usage: '<package>'
				execute: uninstall
			},
			cli.Command{
				name: 'update'
				description: 'update all repos'
				execute: update
			},
			cli.Command{
				name: 'upgrade'
				description: 'upgrade all packages'
				execute: upgrade
			},
			cli.Command{
				name: 'search'
				usage: '[<search_term>]'
				description: 'search for a package name in all repos. If no search_term is provided, all packages will be displayed'
				execute: search
			},
			cli.Command{
				name: 'list'
				usage: '[<search_term>]'
				description: 'list packages installed. If no search_term is provided, all packages will be displayed'
				execute: list
			},
			cli.Command{
				name: 'config'
				description: 'config management tools'
				execute: fn (cmd cli.Command) ! {
					cmd.execute_help()
				}
				commands: [
					cli.Command{
						name: 'set'
						description: 'set config variables'
						execute: fn (cmd cli.Command) ! {
							cmd.execute_help()
						}
						commands: [
							cli.Command{
								name: 'bin_dir'
								usage: '<path>'
								description: 'where binaries will be symlinked'
								required_args: 1
								execute: config_set_bin_dir
							},
							cli.Command{
								name: 'install_dir'
								usage: '<path>'
								description: 'where packages datas will be installed'
								required_args: 1
								execute: config_set_install_dir
							},
						]
					},
					cli.Command{
						name: 'add-repo'
						usage: '<url>'
						description: 'add a url of a list of package'
						required_args: 1
						execute: config_add_repo
					},
				]
			},
		]
	}
	app.setup()
	app.parse(os.args)
}

module main

import paq
import os
import cli

fn get_config() !paq.Config {
	return paq.Config.new()!
}

fn install(cmd cli.Command) ! {
	mut config := get_config()!
	paq.install_paq(mut config, cmd.args[0], cmd.args[1])!
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
	paq.upgrade_paq(mut config)!
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
		description: 'WIP side project package manager'
		execute: fn (cmd cli.Command) ! { cmd.execute_help() }
		version: '0.4.0'
		commands: [
			cli.Command{
				name: 'install'
				description: 'install a package from a package list'
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
				description: 'update all list of packages'
				execute: update
			},
			cli.Command{
				name: 'upgrade'
				description: 'upgrade all packages'
				execute: upgrade
			},
			cli.Command{
				name: 'config'
				description: 'config management tools'
				execute: fn (cmd cli.Command) ! { cmd.execute_help() }
				commands: [
					cli.Command{
						name: 'set'
						description: 'set config variables'
						execute: fn (cmd cli.Command) ! { cmd.execute_help() }
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
							}
						]
					},
					cli.Command{
						name: 'add-repo'
						usage: '<url>'
						description: 'add a url of a list of package'
						required_args: 1
						execute: config_add_repo
					}
				]
			}
		]
	}
	app.setup()
	app.parse(os.args)
}
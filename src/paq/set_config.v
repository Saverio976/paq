module paq

pub fn set_config_install_dir(mut config Config, install_dir string) ! {
	config.set_install_dir(install_dir)!
	config.save()!
}

pub fn set_config_bin_dir(mut config Config, bin_dir string) ! {
	config.set_bin_dir(bin_dir)!
	config.save()!
}

pub fn add_config_repo(mut config Config, repo_url string) ! {
	config.add_repo(repo_url)!
	config.save()!
}

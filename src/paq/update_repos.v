module paq

pub fn update_repos(mut config Config) ! {
	for mut repo in config.repos {
		repo.update_file_cached()!
	}
}

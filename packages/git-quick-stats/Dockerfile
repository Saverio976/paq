from debian:12-slim

# install deps
run apt-get update -y && apt-get install -y curl tar gzip

# get binary + files
run curl -Lo /tmp/git-quick-stats "https://raw.githubusercontent.com/arzzen/git-quick-stats/$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/arzzen/git-quick-stats/releases/latest' | cut -d'/' -f8)/git-quick-stats"
run curl -Lo /tmp/README.md https://raw.githubusercontent.com/arzzen/git-quick-stats/master/README.md
run curl -Lo /tmp/LICENSE https://raw.githubusercontent.com/arzzen/git-quick-stats/master/LICENSE
run chmod +x /tmp/git-quick-stats

# generate files packaged to a temporary directory
run mkdir -p /tmp/out/bin
run cp /tmp/git-quick-stats /tmp/out/bin/git-quick-stats
run cp /tmp/README.md /tmp/out/README.md
run cp /tmp/LICENSE /tmp/out/LICENSE
COPY ./metadata.toml /tmp/out/metadata.toml
run echo "version = \"$(curl -Ls -o /dev/null -w %{url_effective} 'https://github.com/arzzen/git-quick-stats/releases/latest' | cut -d'/' -f8)\"" >> /tmp/out/metadata.toml

# cmd
cmd cp -r /tmp/out/* /out

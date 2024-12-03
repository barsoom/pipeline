class Api::CloudInitsController < ApiController
  # This bootstraps github actions runners.
  def show
    data =
      {
	users: [
	  {
	    name: "username",
	    plain_text_passwd: "password",
	    lock_passwd: false,
	    chpasswd: { expire: false },
	    sudo: "ALL=(ALL) NOPASSWD:ALL",
	    shell: "/bin/bash",
	  }
	],
	disable_root: true,
	ssh_pwauth: false,
	ssh_deletekeys: true,
	packages: [ "curl", "jq" ],
	package_update: true,
	package_upgrade: true,
	write_files: [
	  {
	    path: "/etc/environment",
	    content: "RUNNER_CFG_PAT=#{App.github_actions_runner_cfg_pat}",
            append: true,
	  },
	],
	runcmd: [
	  "systemctl stop sshd",
	  "systemctl disable sshd",
	  "curl https://maintenance.auctionet.dev/running; true",

          # The script relies on running sudo but we've disabled root which means it will bring up a prompt to set a password. Running su will run it as the default user that can sudo and also reload the /etc/environment variables.
          # -f replaces any existing runner with the same name so that you can reinstall a runner and have it replace the old one.
          "su username -c 'cd; curl -s https://raw.githubusercontent.com/actions/runner/main/scripts/create-latest-svc.sh | bash -s -- -f -s #{App.github_actions_runner_scope}'",

          # git clone https://github.com/vbem/multi-runners
          # MR_GITHUB_PAT=... in .env
          # ./mr.bash add --org #{App.github_actions_runner_scope} --count 3

	  "curl https://maintenance.auctionet.dev/it-ran; true",
	  "reboot",
	],
      }

    yaml = "#cloud-config\n" +
      data
      .deep_stringify_keys
      .to_yaml.sub("---", "")

    render plain: yaml, content_type: "text/cloud-config"
  end
end

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
	    shell: "/bin/bash"
	  }
	],
	disable_root: true,
	ssh_pwauth: false,
	ssh_deletekeys: true,
	packages: [ "curl" ],
	package_update: true,
	package_upgrade: true,
	write_files: [
	  {
	    path: "/etc/motd",
	    content: "Hello there."
	  }
	],
	runcmd: [
	  "systemctl stop sshd",
	  "systemctl disable sshd",
	  "curl https://maintenance.auctionet.dev/it-ran",
	  "reboot"
	]
      }

    yaml = "#cloud-config\n" +
      data
      .deep_stringify_keys
      .to_yaml.sub("---", "")

    render plain: yaml, content_type: "text/cloud-config"
  end
end

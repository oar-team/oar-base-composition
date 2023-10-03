# OAR composition with nixos-compose

## Summary

This is a minimal nixos-composition for OAR development.

### Requirements

- You need to have cgroup V1 activated
    - On systemd based distro this does the trick: https://wiki.archlinux.org/title/Cgroups#Tips_and_tricks
    - On nixos: set this option to false
- docker and docker-compose # to use nxc on your laptop with docker
- TODO: qemu ? # to use nxc on your laptop with qemu

## Get nixos-compose

### TODO Coming from python

First install nixos-compose with pip.

```
pip install --user nixos-compose
```

### Coming from nix

If you already have a nix installation, the best way to get started is to install nixos-compose via:

```
nix develop
```

This command should drop you into a shell with nxc available `nxc --version`.

## Build and Run with docker and docker-compose

The simplest way to start the oar cluster is to run the following commands:

```
# Build the composition
nxc build -f docker
# Start the containers
nxc start # or nxc start -r node=5 to start a cluster with 5 nodes
# And connect to the cluster
nxc connect # or nxc connect {frontend,nodeX,server}
```

### Web interfaces

The Drawgantt, rest and monika are available at `localhost:8000`.

- http://localhost:8000/drawgantt/
- http://localhost:8000/monika
- http://localhost:8000/api
- http://localhost:8000/api/docs

### Development

To change the oar version deployed, one can edit the `setum.toml` file at the root of the project.
For instance add a new top level key `laptop` with the following:

```
[laptop.build.nur.repos.kapack.oar]
src = "/path/to/your/oar3/sources"
```

To active the `laptop` key you need to add the `-s laptop` parameter to the build command such as:

```
nxc build -r node=5 -f docker -s laptop
# then nxc start as usual
```

It is also possible to point directly to your github fork, or any revision of oar3. 
For instance:

```
[laptop.build.nur.repos.kapack.oar.src.fetchFromGitHub]
owner = "oar-team"
repo = "oar3"
rev = "237e37ca83b4be3b8a1e6930199d4ad21222ece6"
sha256 = "sha256-8l0jcuV+FbFpCWktqzgbvu+K+/Rh/5fCX8VvH0JaG7E="
```

## Configure OAR

### Configuration

To modify the OAR configuration, you can edit the file `common_config.nix` to add a new configuration variable.
The nix variable to edit is `services.oar.extraConfig`.


For instance, change the default log level:

```
extraConfig = {
  LOG_LEVEL = "3";
  HIERARCHY_LABELS = "resource_id,network_address,cpuset";
};
```


### Cluster initialization

Currently the cluster initialization (adding resources properties and creating resources) is made in the `postInitCommands` of the oar database service. It is also located in the file `common_config.nix`.

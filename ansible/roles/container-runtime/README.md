# Container Runtime

- [Container Runtime](#container-runtime)
  - [Overview](#overview)
  - [Important Points](#important-points)
  - [Important Reading](#important-reading)
      - [Cgroup drivers](#cgroup-drivers)
      - [Enable CRI Plugin](#enable-cri-plugin)
## Overview
Review following articles on container runtime.

- https://kubernetes.io/docs/setup/production-environment/container-runtimes/
- https://www.tutorialworks.com/difference-docker-containerd-runc-crio-oci/#:~:text=CRI%2DO%20is%20another%20high,O%20is%20another%20container%20runtime.


## Important Points
- We are using `systemd` as [Cgroup driver](#cgroup-drivers)
- We do generate `/etc/containerd/config.toml` from default containerd config

## Important Reading

#### Cgroup drivers
There are two cgroup drivers available:

- cgroupfs
- systemd

The cgroupfs driver is not recommended when systemd is the init system because systemd expects a single cgroup manager on the system. Additionally, if you use cgroup v2 , use the systemd cgroup driver instead of cgroupfs.

***Identify the cgroup version on Linux Nodes***
```bash
$ stat -fc %T /sys/fs/cgroup/
cgroup2fs
```

For cgroup v2, the output is cgroup2fs.
For cgroup v1, the output is tmpfs.
[Source](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)

#### Enable CRI Plugin
If you installed containerd from a package (for example, RPM or .deb), you may find that the CRI integration plugin is disabled by default.

You need CRI support enabled to use containerd with Kubernetes. Make sure that cri is not included in the `disabled_plugins` list within `/etc/containerd/config.toml`; if you made changes to that file, also restart containerd.

If you experience container crash loops after the initial cluster installation or after installing a CNI, the containerd configuration provided with the package might contain incompatible configuration parameters. Consider resetting the containerd configuration with `containerd config default > /etc/containerd/config.toml` as specified in getting-started.md and then set the configuration parameters specified above accordingly.
[Source](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)


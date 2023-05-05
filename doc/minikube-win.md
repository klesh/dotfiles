

# podman will not work since cgroup2 is not working by WSL2

1. install virtualbox
2. download `minikube.exe` for windows and add it to the `PATH`
2. launch with proxy
```
$env:HTTPS_PROXY = 'http://host:port'
minikube start
```

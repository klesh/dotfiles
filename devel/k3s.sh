#!/bin/sh

if [ "$#" -lt 3 ]; then
    echo "This script will try to setup k3s on a remote server which unfortunately located in YOUR COUNTRY!"
    echo "      Usage: $0 <user@host> <external-ip> <email>"
    exit 0
fi


DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

SSH=$1
IP=$2
EMAIL=$3
CERT_MANAGER=https://github.com/jetstack/cert-manager/releases/download/v0.11.0/cert-manager.yaml

# install ks3
ssh "$SSH" '
if ! command -v k3s >/dev/null ; then
    export INSTALL_K3S_MIRROR=cn
    export INSTALL_K3S_VERSION=v1.20.0-k3s2
    export INSTALL_K3S_EXEC="--tls-san '"$IP"' --node-external-ip '"$IP"' --disable traefik --default-local-storage-path /data"
    curl -sfL http://rancher-mirror.cnrancher.com/k3s/k3s-install.sh | sh -
fi
'

# setup mirror
ssh "$SSH" '
CFG_DIR=/var/lib/rancher/k3s/agent/etc/containerd

while ! sudo stat $CFG_DIR/config.toml >/dev/null 2>&1; do
    echo waiting k3s to startup $CFG_DIR/config.toml
    sleep 3
done

if ! sudo grep -qF "mirrors" $CFG_DIR/config.toml; then
    echo "[plugins.cri.registry.mirrors]"                   | sudo tee -a $CFG_DIR/config.toml
    echo "  [plugins.cri.registry.mirrors.\"docker.io\"]"   | sudo tee -a $CFG_DIR/config.toml
    echo "    endpoint = ["                                 | sudo tee -a $CFG_DIR/config.toml
    echo "      \"https://1nj0zren.mirror.aliyuncs.com\","  | sudo tee -a $CFG_DIR/config.toml
    echo "      \"https://docker.mirrors.ustc.edu.cn\","    | sudo tee -a $CFG_DIR/config.toml
    echo "      \"http://f1361db2.m.daocloud.io\"]"         | sudo tee -a $CFG_DIR/config.toml
fi
sudo cp $CFG_DIR/config.toml $CFG_DIR/config.toml.tmpl
sudo systemctl restart k3s
'

# setup https traefik
scp "$DIR"/k3s/*.yaml "$SSH:"
ssh "$SSH" '
sudo kubectl apply -f traefik-crd.yaml
sed -i "s/EMAIL/'"$EMAIL"'/" traefik-dpy.yaml
sudo kubectl apply -f traefik-dpy.yaml
sudo kubectl wait --for=condition=available --timeout=600s  deployment/traefik -n default
'


# add more workers
echo
echo "add more workers with following command:"
echo "  sudo k3s agent --server https://$IP:6443 --token $(ssh "$SSH" 'sudo cat /var/lib/rancher/k3s/server/node-token')"

# copy kubctl config file content to clipboard
KUBECONFIG=$(
ssh "$SSH" '
sudo sed "s|server:.*|server: https://'"$IP"':6443|" /etc/rancher/k3s/k3s.yaml
')
echo "$KUBECONFIG" | xsel -b
echo "kube config has been copy to clipboard, you can set it as your only k8s cluster with:"
echo "$KUBECONFIG"
echo "  xsel -ob > ~/.kube/config"


# add private registry:
echo
echo "import private registry credentials to your k3s:"
echo "  kubectl create secret generic regcred \\"
echo "      --from-file=.dockerconfigjson=\$HOME/.docker/config.json \\"
echo "      --type=kubernetes.io/dockerconfigjson"

echo
echo "add private registry manually:"
echo "  kubectl create secret docker-registry regcred \\"
echo "      --docker-server=<your-registry-server> \\"
echo "      --docker-username=<your-name> \\"
echo "      --docker-password=<your-pword> --docker-email=<your-email>"


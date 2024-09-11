# Start delete ubuntu user
sudo deluser --remove-home ubuntu
# End delete ubuntu user

# Start configure zsh
cat <<EOF > /home/zp4rker/.zshrc
# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle :compinstall filename '/home/zp4rker/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=/home/zp4rker/.config/zsh/histfile
HISTSIZE=1000
SAVEHIST=5000
bindkey -e
# End of lines configured by zsh-newuser-installa

# Setup antigen
export ADOTDIR="/home/zp4rker/.config/zsh/antigen"
source /home/zp4rker/.config/zsh/antigen.zsh
antigen init /home/zp4rker/.config/zsh/antigen/antigenrc
# End of antigen setup

# Setup PROMPT
PROMPT='%B%F{10}%n@%M%b%f:%B%F{4}%~%f%b%(!.#.$) '
# End of PROMPT setup
EOF
mkdir -p .config/zsh/antigen
curl -L git.io/antigen > .config/zsh/antigen.zsh
cat <<EOF > /home/zp4rker/.config/zsh/antigen/antigenrc
antigen use oh-my-zsh

antigen bundle command-not-found

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle robsis/zsh-completion-generator

antigen apply
EOF
sudo chsh -s /bin/zsh zp4rker
# End configure zsh

# Start flush iptables rules
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X
sudo ip6tables -P INPUT ACCEPT
sudo ip6tables -P FORWARD ACCEPT
sudo ip6tables -P OUTPUT ACCEPT
sudo ip6tables -t nat -F
sudo ip6tables -t mangle -F
sudo ip6tables -F
sudo ip6tables -X
# End flush iptables rules


# Start setup ufw
cat <<EOF | sudo tee -a /etc/ufw/ufw.conf

# Disable IPv6 rules
IPV6=no
EOF
sudo ufw allow 22/tcp
sudo ufw allow 80,443/tcp
sudo ufw enable
# End setup ufw

# Start install docker
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -a -G docker zp4rker
# End install docker

# Start setup sslh
sudo mkdir /sslh
sudo chmod a=rwx /sslh
cat <<EOF > /sslh/docker-compose.yml
services:
  sslh:
    image: ghcr.io/yrutschle/sslh:latest
    container_name: sslh
    command: --foreground --listen 0.0.0.0:80 --ssh localhost:22 --http localhost:8080
    cap_add:
      - NET_RAW
      - NET_BIND_SERVICE
    network_mode: host
    restart: unless-stopped
EOF
newgrp docker
docker compose -f /sslh/docker-compose.yml up -d
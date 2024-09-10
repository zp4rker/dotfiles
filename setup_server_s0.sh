# Start ensure up-to-date packages
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
# End ensure up-to-date packages

# Start install basics
sudo apt update -y
sudo apt install zsh git python-is-python3 ufw cron -y
# End install basics

# Start setup user
sudo adduser --disabled-password --gecos "" zp4rker
cat <<EOS | exec sudo -u zp4rker sh
mkdir -p ~/.ssh
chmod u=rwx,og= ~/.ssh
curl https://github.com/zp4rker.keys -o ~/.ssh/authorized_keys >/dev/null 2>&1
chmod u=rw,og= ~/.ssh/authorized_keys
(crontab -l 2>/dev/null; echo "0 */6 * * * curl https://github.com/zp4rker.keys -o ~/.ssh/authorized_keys >/dev/null 2>&1") | crontab -
EOS
echo "zp4rker ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/zp4rker
sudo chmod ug=r,o= /etc/sudoers.d/zp4rker
sudo deluser --remove-home ubuntu
# End setup user

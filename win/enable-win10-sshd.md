# Check if Server/Client installed
```
Get-WindowsCapability -Online | ? Name -like 'OpenSSH*'
```
# Install the OpenSSH Client
```
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

# Install the OpenSSH Server
```
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```
# Start server
```
Start-Service sshd
```
# Enable sshd
```
Set-Service -Name sshd -StartupType 'Automatic'
# Confirm the Firewall rule is configured. It should be created automatically by setup.
Get-NetFirewallRule -Name *ssh*
# There should be a firewall rule named "OpenSSH-Server-In-TCP", which should be enabled
# If the firewall does not exist, create one
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

# Get PublicKey authentication works
Following are setup steps for OpenSSH shipped with Windows 10 v.1803 (April 2018 update. See comments to this post, it might not work with 1809).

Server setup (elevated powershell):

Install OpenSSH server: Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0.

Start agent and sshd services: Start-Service ssh-agent; Start-Service sshd (this will generate host keys and default configuration automatically in $env:ProgramData\ssh).

[Optional] Install OpenSSHUtils powershell module: Install-Module -Force OpenSSHUtils

Client setup (non-elevated powershell):

Generate user key: cd $env:USERPROFILE\.ssh; ssh-keygen.exe, follow prompts, agree to the default suggested file location. This will create 2 files: id_rsa and id_rsa.pub;

[Optional] add key to authentication agent, so you don't have to enter password each time you use it: ssh-add .\id_rsa (or whatever file was generated);

Server setup continued (non-elevated powershell):

Log in as a user, for which public key auth to be used
cd $env:USERPROFILE; mkdir .ssh; cd .ssh; New-Item authorized_keys;
Paste the contents of the id_rsa.pub file from the client to the .ssh\authorized_keys file from the previous step.
Setup permissions properly (important!!!):
Run start . to open explorer with the current folder ($env:USERPROFILE\.ssh);
Right click authorized_keys, go to Properties -> Security -> Advanced
Click "Disable inheritance";
Choose "Convert inherited permissions into explicit permissions on this object" when prompted;
(really, really important) Remove all permissions on file except for the SYSTEM and yourself. There must be exactly two permission entries on the file. Some guides suggest running the Repair-AuthorizedKeyPermission $env:USERPROFILE\.ssh\authorized_keys - this will try to add the sshd user to the permission list and it will break the authentication, so, don't do that, or at least do not agree on adding the sshd user). Both SYSTEM and yourself should have full control over the file.
If your Windows build is 1809 or later, it is required to comment out the following lines in C:\ProgramData\ssh\sshd_config file. Then restart the sshd service.
# Match Group administrators                                                    
#       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys  
Client:

Run ssh <serverusername>@<serverhostname>. It should work at this point.
Tried that with Windows 10 as server and both itself and a Debian Linux as a client.
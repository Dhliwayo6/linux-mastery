-- Seed data for learning modules, sections and quiz questions

-- 1. Modules
INSERT INTO modules (id, slug, title, description, level, order_index) VALUES
('mod-1', 'linux-fundamentals', 'Linux Fundamentals & File System', 'The foundation for everything: containers, SSH, logs, and config.', 'Beginner', 1)
ON DUPLICATE KEY UPDATE title=VALUES(title), description=VALUES(description), level=VALUES(level);

INSERT INTO modules (id, slug, title, description, level, order_index) VALUES
('mod-2', 'users-permissions', 'Users, Permissions & Ownership', 'The security model used in every Linux environment.', 'Beginner', 2)
ON DUPLICATE KEY UPDATE title=VALUES(title), description=VALUES(description), level=VALUES(level);

INSERT INTO modules (id, slug, title, description, level, order_index) VALUES
('mod-3', 'processes-resources', 'Processes & System Resources', 'Debug crashes, monitor services, understand the kernel.', 'Intermediate', 3)
ON DUPLICATE KEY UPDATE title=VALUES(title), description=VALUES(description), level=VALUES(level);

INSERT INTO modules (id, slug, title, description, level, order_index) VALUES
('mod-4', 'networking-basics', 'Networking Basics', 'Ports, DNS, SSH, sockets -- core to all distributed systems.', 'Intermediate', 4)
ON DUPLICATE KEY UPDATE title=VALUES(title), description=VALUES(description), level=VALUES(level);

INSERT INTO modules (id, slug, title, description, level, order_index) VALUES
('mod-5', 'systemd-services-logs', 'systemd, Services & Logs', 'How production services run and how to fix them.', 'Intermediate', 5)
ON DUPLICATE KEY UPDATE title=VALUES(title), description=VALUES(description), level=VALUES(level);

INSERT INTO modules (id, slug, title, description, level, order_index) VALUES
('mod-6', 'containers-kubernetes', 'Linux for Containers & Kubernetes', 'Namespaces, cgroups, the Linux primitives powering Docker and K8s.', 'Advanced', 6)
ON DUPLICATE KEY UPDATE title=VALUES(title), description=VALUES(description), level=VALUES(level);

INSERT INTO modules (id, slug, title, description, level, order_index) VALUES
('mod-7', 'shell-scripting', 'Shell Scripting & Automation', 'Write real DevOps tooling and automate repetitive tasks.', 'Bonus', 7)
ON DUPLICATE KEY UPDATE title=VALUES(title), description=VALUES(description), level=VALUES(level);

-- 2. Sections
INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-1-1', 'mod-1', 'Core Mental Model: Everything Is a File', '### Core Mental Model: Everything Is a File

KEY IDEA

Everything is a file. Your hard drive, a running process, a network socket, a USB device,
system settings — all represented as files somewhere on the filesystem. This is not a
metaphor. It is literally how the kernel works.', 1)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-1-2', 'mod-1', 'The Filesystem Tree', '### The Filesystem Tree

| Directory | Purpose | What lives here |
|---|---|---|
| `/` | Root | The top of the entire filesystem — everything is under here |
| `/etc` | Edit to Configure | Config files for every installed service (nginx, ssh, apt, etc.) |
| `/home` | Home directories | Each user''s personal folder, e.g. `/home/mandisi` |
| `/var` | Variable data | Logs, databases, spool files — data that grows over time |
| `/proc` | Process filesystem | Virtual: the kernel writes live process and hardware info here |
| `/usr` | Unix System Resources | Installed programs, libraries, documentation |
| `/tmp` | Temporary | Scratch space, cleared on reboot |
| `/bin` | Binaries | Essential system commands (`ls`, `cat`, `cp`) |
| `/dev` | Devices | Device files: `/dev/sda` (hard drive), `/dev/null`, `/dev/random` |
| `/root` | Root user home | The admin user''s home folder — NOT the same as `/`', 2)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-1-3', 'mod-1', 'Essential Commands', '### Essential Commands

```bash
Navigation
pwd                            # Where am I right now?
ls                             # List files in current directory
ls -la                         # Long format + hidden files (files starting with .)
cd /etc                        # Change into /etc (absolute path)
cd ~                           # Go to your home directory
cd ..                          # Go up one level
cd -                           # Go back to previous directory
```

ANALOGY

pwd = ''What street am I on?'' ls = looking at buildings around you cd = walking to a new
location', 3)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-1-4', 'mod-1', 'Reading Files', '### Reading Files

```bash
cat /etc/hostname              # Print entire file to screen
less /var/log/syslog           # Scroll through a file (q to quit)
head -n 20 file.log            # First 20 lines
tail -n 20 file.log            # Last 20 lines
tail -f /var/log/syslog        # Follow a log in real time (Ctrl+C to stop)
```', 4)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-1-5', 'mod-1', 'Finding Things', '### Finding Things

```bash
find / -name ''nginx.conf''      # Search entire filesystem
find /var/log -name ''*.log''    # All .log files under /var/log
find /home -type d             # Find only directories
find . -name ''*.java'' -mtime -7 # Java files modified in last 7 days
which python3                  # Where is the python3 binary?
man ls                         # Full manual page for ls
```', 5)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-1-6', 'mod-1', 'From Our Session: Real Output on Your Machine', '### From Our Session: Real Output on Your Machine

Your ip addr output confirmed your machine has four network interfaces. Understanding the
filesystem helped you navigate these directly in /proc and /sys throughout the curriculum.', 6)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-1-7', 'mod-1', 'Common Mistakes to Avoid', '### Common Mistakes to Avoid

```bash
•​
•​
•​
•​
```

Confusing / (root directory) with /root (root user''s home). They are completely different.
Running sudo without understanding the command first. Read before you execute.
Forgetting hidden files. Files starting with . are invisible to plain ls. Always use ls -la.
Confusing absolute paths (start with /) and relative paths (start from current location).', 7)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-1-8', 'mod-1', 'Mini Project: sysinfo.sh', '### Mini Project: sysinfo.sh

```bash
echo "Hostname: $(hostname)"
echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2)"
df -h /
du -sh /var/log/* 2>/dev/null | sort -rh | head -5
echo "Date: $(date)"
```', 8)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-1-9', 'mod-1', 'Connection to Kubernetes', '### Connection to Kubernetes

When you run kubectl exec -it pod-name -- /bin/bash to get a shell inside a pod, you land in a
Linux filesystem navigating with these exact commands. The container''s /etc holds its config, its
/var/log holds its logs.', 9)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-2-1', 'mod-2', 'Core Mental Model', '### Core Mental Model

KEY IDEA

Every file has an owner (a user) and a group. Every file has three sets of permissions:
what the owner can do, what the group can do, and what everyone else can do.', 1)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-2-2', 'mod-2', 'Reading Permission Strings', '### Reading Permission Strings

```bash
-rwxr-xr-- 1 mandisi developers 4096 Apr 20 script.sh
```

Break it down:
* `-` = file type (`-` = file, `d` = directory, `l` = symlink)
* `rwx` = owner permissions (read=4, write=2, execute=1)
* `r-x` = group permissions (read=4, execute=1)
* `r--` = others permissions (read=4)', 2)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-2-3', 'mod-2', 'chmod: Changing Permissions', '### chmod: Changing Permissions

#### Symbolic mode
```bash
chmod u+x script.sh       # Give the owner execute permission
chmod g-w file.txt        # Remove write from the group
chmod o+r report.pdf      # Give others read access
chmod a+x deploy.sh       # Give everyone execute
```

#### Numeric (octal) mode
```bash
chmod 755 script.sh       # rwxr-xr-x -- standard for scripts
chmod 644 config.txt       # rw-r--r-- -- standard for config files
chmod 600 id_rsa           # rw------- -- private SSH keys
chmod 700 ~/.ssh           # rwx------ -- SSH directory itself
```

755 for scripts. 644 for config files. 600 for private SSH keys. These three cover 90% of daily use.', 3)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-2-4', 'mod-2', 'chown: Changing Ownership', '### chown: Changing Ownership

```bash
chown mandisi file.txt         # Change owner
chown mandisi:developers file.txt # Change owner AND group
chown :developers file.txt     # Change only the group
chown -R mandisi:developers /app # Recursive — entire directory tree
```', 4)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-2-5', 'mod-2', 'Users and Groups', '### Users and Groups

```bash
whoami                    # Which user am I?
id                        # My UID, GID, and every group I belong to
groups mandisi            # Which groups does mandisi belong to?
cat /etc/passwd           # All users on the system
sudo useradd -m alice     # Create user with home directory
sudo usermod -aG sudo alice # Add to sudo group (-a is critical — append, not replace)
sudo userdel -r alice     # Delete user AND home directory
```

> [!NOTE]
> **SECURITY NOTE**
> Running services as root is dangerous. In containers, running as root is a known security vulnerability. Always run services as a dedicated non-root user.', 5)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-2-6', 'mod-2', 'From Our Session: Your SSH Directory', '### From Our Session: Your SSH Directory

Your ls -la ~/.ssh output showed correct permissions: drwx------ (700) on the .ssh directory and
-rw------- (600) on id_rsa. SSH enforces these — it refuses to use a private key with permissions
looser than 600.', 6)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-2-7', 'mod-2', 'Permission Reference Table', '### Permission Reference Table

| Octal | Symbolic | Meaning |
|---|---|---|
| 7 | rwx | Read, write, and execute |
| 6 | rw- | Read and write |
| 5 | r-x | Read and execute |
| 4 | r-- | Read only |
| 0 | --- | No permissions |', 7)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-2-8', 'mod-2', 'Mini Project: permission_audit.sh', '### Mini Project: permission_audit.sh

```bash
set -euo pipefail
echo ''=== Current user ===''
```

```bash
whoami
echo ''''
echo ''=== Groups ===''
groups
echo ''''
echo ''=== Home directory permissions ===''
ls -ld ~
echo ''''
echo ''=== SSH directory permissions ===''
ls -la ~/.ssh
echo ''''
echo ''=== Executable .sh files in home directory ===''
find ~ -name ''*.sh'' -perm -u+x 2>/dev/null
echo ''''
echo ''=== World-writable files in /etc (security check) ===''
find /etc -perm -o+w 2>/dev/null | wc -l
```', 8)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-2-9', 'mod-2', 'Connection to Kubernetes', '### Connection to Kubernetes

In Kubernetes, runAsUser and runAsNonRoot in a pod''s securityContext reference Linux UIDs
directly from /etc/passwd. fsGroup sets group ownership on mounted volumes — the equivalent
of chown :groupid on the volume at mount time.', 9)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-3-1', 'mod-3', 'Core Mental Model', '### Core Mental Model

KEY IDEA

A process is a running instance of a program. It has a unique PID, belongs to a user,
uses CPU and memory, and can have child processes. Every process has a live folder
at /proc/[PID]/ written by the kernel in real time.', 1)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-3-2', 'mod-3', 'Viewing Processes', '### Viewing Processes

```bash
ps aux                # Show all running processes (snapshot)
ps aux | grep nginx   # Find a specific process
ps -ef --forest       # Show process tree with parent-child relationships
ps aux --sort=-%cpu   # Sort by CPU usage, highest first
ps aux --sort=-%mem   # Sort by memory usage, highest first
top                   # Live process monitor (q to quit)
htop                  # Better live process monitor (interactive)
```

| Column | Meaning |
|---|---|
| `USER` | Which user owns the process |
| `PID` | Process ID — unique identifier assigned by the kernel |
| `%CPU` | Percentage of CPU being used |
| `%MEM` | Percentage of RAM being used |
| `RSS` | Resident Set Size — RAM actually in use right now (the number that matters) |
| `VSZ` | Virtual memory size — total claimed (often much higher than RSS) |
| `STAT` | R=running, S=sleeping, Z=zombie, D=uninterruptible sleep, T=stopped |
| `COMMAND` | The command that started this process |', 2)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-3-3', 'mod-3', 'Signals and kill', '### Signals and kill

| Signal | Number | When to use |
|---|---|---|
| `SIGTERM` | 15 | Polite shutdown request — try this first. Process can clean up. |
| `SIGKILL` | 9 | Force kill — cannot be caught or ignored. Last resort only. |
| `SIGHUP` | 1 | Reload configuration without restarting. Used by nginx, sshd. |
| `SIGINT` | 2 | What Ctrl+C sends. Interrupt from keyboard. |

```bash
kill 1234             # Send SIGTERM to PID 1234
kill -9 1234          # Send SIGKILL — immediate forced termination
kill -HUP 1234         # Send SIGHUP — reload config
killall nginx         # Kill all processes named nginx
pkill -f ''python app'' # Kill processes matching a pattern
```

> [!IMPORTANT]
> **GOLDEN RULE**
> Always try SIGTERM first. Give the process 5-10 seconds to shut down cleanly. Only use kill -9 if it does not respond. SIGKILL gives the process zero time to flush buffers or close database connections.', 3)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-3-4', 'mod-3', 'Background Jobs', '### Background Jobs

```bash
sleep 300 &
jobs
fg %1
bg %1
Ctrl+Z
Ctrl+C
nohup ./script.sh &
```

```bash
# Start a job in the background
# List background jobs in this shell session
# Bring job 1 to the foreground
# Resume a stopped job in the background
# Pause the foreground process
# Terminate the foreground process (SIGINT)
# Run something that survives when you close the terminal
```', 4)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-3-5', 'mod-3', 'The /proc Filesystem', '### The /proc Filesystem

```bash
echo $$                        # $$ = your shell''s own PID
cat /proc/$$/status            # Your shell''s status: name, state, memory
cat /proc/$$/cmdline           # The command that started your shell
ls /proc/$$/fd/                # Files your shell has open
cat /proc/loadavg              # System load averages (1min, 5min, 15min)
cat /proc/meminfo              # Detailed memory breakdown
```', 5)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-3-6', 'mod-3', 'Mini Project: process_monitor.sh', '### Mini Project: process_monitor.sh

```bash
set -euo pipefail
echo ''=============================''
echo '' Process Health Monitor''
echo ''=============================''
echo ''''
echo ''--- Load Averages ---''
uptime
```

```bash
echo ''''
echo ''--- CPU Cores ---''
nproc
echo ''''
echo ''--- Top 5 Processes by CPU ---''
ps aux --sort=-%cpu | head -6
echo ''''
echo ''--- Top 5 Processes by Memory ---''
ps aux --sort=-%mem | head -6
echo ''''
echo ''--- Checking if bash is running ---''
if pgrep -x bash > /dev/null; then
echo ''bash is running''
else
echo ''bash is NOT running''
fi
echo ''''
echo ''--- Memory Usage ---''
free -h
echo ''''
echo ''--- Disk Usage Check ---''
DISK_USAGE=$(df / | awk ''NR==2 {print $5}'' | tr -d ''%'')
if [ "$DISK_USAGE" -gt 80 ]; then
echo "WARNING: Disk is ${DISK_USAGE}% full"
else
echo "Disk usage is OK: ${DISK_USAGE}%"
fi
```

Command Breakdown: Disk Check Pipeline
DISK_USAGE=$(df / | awk ''NR==2 {print $5}'' | tr -d ''%'')
df /
awk ''NR==2 ...''
{print $5}
tr -d ''%''

-> two-line table (header + data row)
-> take only line 2 (NR = line Number of Record)
-> print the 5th column (Use%)
-> delete the % character so we get a plain number', 6)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-3-7', 'mod-3', 'Connection to Kubernetes', '### Connection to Kubernetes

When you set resources.limits.memory in a Kubernetes pod spec, that maps to Linux cgroup
limits. The %CPU and %MEM values in ps aux are the same metrics kubelet uses to schedule
and evict pods.', 7)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-4-1', 'mod-4', 'Core Mental Model', '### Core Mental Model

| Interface | IP | Status | What it is |
|---|---|---|---|
| `lo` | `127.0.0.1/8` | UP | Loopback — your machine talking to itself |
| `enp2s0` | (no IP) | DOWN | Wired ethernet — nothing plugged in (NO-CARRIER) |
| `wlp3s0` | `192.168.1.45/24` | UP | Wireless Wi-Fi — connected to local router |
| `docker0` | `172.17.0.1/16` | UP | Docker bridge interface for container networking |', 1)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-4-2', 'mod-4', 'Checking Listening Ports', '### Checking Listening Ports

```bash
ss -tulnp                      # All listening ports with process info
ss -tulnp | grep :80           # t=TCP u=UDP l=listening n=numeric p=process
ss -tulnp | grep :8080         # Is anything on port 80?
lsof -i :8080                  # Is my app listening?
```

KEY
DISTINCTI
ON

0.0.0.0:5432 = listening on ALL interfaces (reachable from outside) 127.0.0.1:5432 =
loopback only (only local processes can connect). Databases should almost always be
127.0.0.1, not 0.0.0.0.', 2)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-4-3', 'mod-4', 'Testing Connectivity', '### Testing Connectivity

```bash
ping -c 4 8.8.8.8              # Test basic connectivity (sends 4 packets)
curl https://google.com        # Make an HTTP GET request
curl -I https://google.com     # Response headers only
curl -v https://httpbin.org/get # Verbose — full request and response # Test if a port is open (netcat)
```', 3)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-4-4', 'mod-4', 'DNS', '### DNS

```bash
dig google.com +short          # Resolve a hostname to IP
cat /etc/resolv.conf           # Which DNS server your machine uses
cat /etc/hosts                 # Local overrides — checked BEFORE DNS
```

```bash
echo ''127.0.0.1 myapp.local'' | sudo tee -a /etc/hosts # Add a local override for testing:
```', 4)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-4-5', 'mod-4', 'SSH', '### SSH

```bash
ssh user@192.168.1.20          # Connect to a remote server
ssh -i ~/.ssh/id_rsa user@server # Use specific key # Copy public key to server''s authorized_keys
```

SSH Config File
# ~/.ssh/config
Host devserver
HostName 192.168.1.20
User mandisi
IdentityFile ~/.ssh/id_rsa
Port 22
# chmod 600 ~/.ssh/config
# Then just run: ssh devserver', 5)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-4-6', 'mod-4', 'Common Ports Reference', '### Common Ports Reference

| Port | Service | Common use |
|---|---|---|
| `22` | SSH | Remote server access |
| `80` | HTTP | Web traffic, nginx, reverse proxies |
| `443` | HTTPS | Secure web traffic |
| `53` | DNS | Name resolution |
| `3306` | MySQL | Database |
| `5432` | PostgreSQL | Database |
| `6379` | Redis | Cache / Key-value store |
| `8080` | Custom App | Java/Spring, Node.js, python servers |', 6)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-4-7', 'mod-4', 'Mini Project: network_audit.sh', '### Mini Project: network_audit.sh

```bash
set -euo pipefail
echo ''=============================''
echo '' Network Audit''
echo ''=============================''
echo ''''
echo ''--- Machine IP Address ---''
hostname -I
echo ''''
echo ''--- Listening Ports ---''
ss -tulnp
echo ''''
echo ''--- Internet Connectivity Test ---''
if ping -c 2 8.8.8.8 > /dev/null 2>&1; then
echo ''Internet is reachable''
else
echo ''WARNING: Cannot reach 8.8.8.8''
fi
echo ''''
echo ''--- DNS Resolution Check ---''
echo -n ''google.com:
''
dig google.com +short | head -1
echo -n ''github.com:
''
dig github.com +short | head -1
echo ''''
echo ''--- SSH Port Check ---''
if ss -tulnp | grep -q '':22''; then
echo ''SSH is listening on port 22''
else
echo ''SSH is NOT listening on port 22''
fi
echo ''''
echo ''--- DNS Server ---''
DNS_SERVER=$(grep ''^nameserver'' /etc/resolv.conf | head -1 | awk ''{print $2}'')
```

```bash
echo "DNS Server: $DNS_SERVER"
```', 7)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-4-8', 'mod-4', 'Connection to Kubernetes', '### Connection to Kubernetes

Kubernetes Services are iptables rules managed by kube-proxy. DNS in pods uses
/etc/resolv.conf pointing to kube-dns. kubectl port-forward uses the same socket concepts
covered here. Network policies map to iptables rules on each node.', 8)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-5-1', 'mod-5', 'Core Mental Model', '### Core Mental Model

KEY IDEA

systemd is PID 1 — the very first process the kernel starts. It starts every other service
in the right order, monitors them, restarts them if they crash, and manages system
lifecycle. journalctl is your window into everything it logs.', 1)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-5-2', 'mod-5', 'Managing Services with systemctl', '### Managing Services with systemctl

sudo systemctl start nginx
# Start right now
sudo systemctl stop nginx
# Stop right now
sudo systemctl restart nginx
# Stop then start (brief downtime)
sudo systemctl reload nginx
# Reload config, no downtime
sudo systemctl enable nginx
# Start automatically on every boot
sudo systemctl disable nginx
# Do not start on boot
sudo systemctl enable --now nginx # Enable AND start in one command
sudo systemctl status nginx
# Full status: state, PID, recent logs
systemctl is-active nginx
# Returns ''active'' or ''inactive''
systemctl list-units --type=service --state=failed # Failed services only

KEY
DISTINCTI
ON

start = run the service NOW | enable = run on every future BOOT | enable --now =
both at once (what you usually want)', 2)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-5-3', 'mod-5', 'Reading Logs with journalctl', '### Reading Logs with journalctl

```bash
journalctl -u nginx            # All logs for nginx
journalctl -u nginx -f         # Follow in real time
journalctl -u nginx -n 50      # Last 50 lines
journalctl -u nginx --since today # Today only
journalctl -u nginx --since ''1 hour ago'' # Errors from nginx only
journalctl -p err -u nginx     # Current boot only
journalctl -b                  # Previous boot
journalctl -b -1               # All recorded boot sessions
journalctl --list-boots        # How much disk the journal uses
journalctl --disk-usage        # Delete logs older than 7 days
```', 3)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-5-4', 'mod-5', 'Writing a systemd Unit File', '### Writing a systemd Unit File

```ini
[Unit]
Description=My Web Application
After=network.target

[Service]
Type=simple
User=myapp
WorkingDirectory=/opt/myapp
ExecStart=/opt/myapp/bin/server
Restart=always

[Install]
WantedBy=multi-user.target
```', 4)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-5-5', 'mod-5', 'From Our Session: Python Server Exercise', '### From Our Session: Python Server Exercise

The step-by-step guide covered creating /etc/systemd/system/pyserver.service, the
daemon-reload workflow, and testing Restart=on-failure by force-killing the process with kill -9
and watching systemd respawn it after RestartSec seconds.', 5)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-5-6', 'mod-5', 'Mini Project: service_manager.sh', '### Mini Project: service_manager.sh

```bash
set -euo pipefail
SERVICE="${1:-}"
if [[ -z "$SERVICE" ]]; then
echo "Usage: $0 <service-name>"
exit 1
fi
echo ''''
```

```bash
echo "=== Service: $SERVICE ==="
echo ''''
echo ''--- Active Status ---''
if systemctl is-active --quiet "$SERVICE"; then
echo ''Service is active''
else
echo ''Service is inactive''
fi
echo ''''
echo ''--- Enabled Status ---''
if systemctl is-enabled --quiet "$SERVICE"; then
echo ''Service is enabled on boot''
else
echo ''Service is NOT enabled on boot''
fi
echo ''''
echo ''--- Last 20 Log Lines ---''
journalctl -u "$SERVICE" -n 20 --no-pager
echo ''''
echo ''--- Errors in the Past Hour ---''
journalctl -u "$SERVICE" -p err --since ''1 hour ago'' --no-pager
echo ''''
echo ''--- Memory Usage ---''
MEMORY=$(systemctl status "$SERVICE" 2>/dev/null | grep -i ''memory'' | awk ''{print
$2}'')
if [[ -n "$MEMORY" ]]; then
echo "Memory usage: $MEMORY"
else
echo ''Memory usage: not available''
fi
```', 6)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-5-7', 'mod-5', 'Connection to Kubernetes', '### Connection to Kubernetes

Kubernetes restart policies mirror systemd Restart= values. kubectl logs -f mirrors journalctl -u
service -f. Both work because the application writes to stdout/stderr and the runtime (systemd or
the container runtime) captures those streams.', 7)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-6-1', 'mod-6', 'Core Mental Model', '### Core Mental Model

KEY IDEA

A container is a regular Linux process wrapped in namespaces (for isolation) and
constrained by cgroups (for resource limits), running on a filesystem assembled from
layered images. Docker and Kubernetes are not magic — they are Linux features with a
friendly API on top.', 1)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-6-2', 'mod-6', 'Namespaces: Isolation', '### Namespaces: Isolation

Namespace

Isolates

What the container sees

PID

Process IDs

PID 1 inside the container (even though it is a high PID on the
host)

Network

Network stack

Its own interfaces, IP address, routing table

Mount

Filesystem mounts

Its own root filesystem, separate from the host''s /

UTS

Hostname

Its own hostname (the container name)

IPC

Inter-process comms

Its own shared memory, message queues

User

User and group IDs

Container root (UID 0) can map to an unprivileged host UID

cgroup

cgroup hierarchy

Only its own slice of the resource tree', 2)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-6-3', 'mod-6', 'Build a Mini Container by Hand', '### Build a Mini Container by Hand

```bash
ps aux                         # Inside the namespace: # return to normal shell
```

Command Breakdown: unshare

Part

What it does

Container equivalent

sudo

Creating namespaces requires
root privileges

Docker daemon runs as root

```bash
unshare
```

Create namespaces, then run a
program inside them

What containerd/runc do on docker run

--pid

Create a new PID namespace —
process numbering restarts from 1

Why ps aux inside a container shows only that
container''s processes

--fork

Fork a child so it properly becomes
PID 1 in the new namespace

Why your app''s process is PID 1 inside the
container

--mountproc

Mount fresh /proc reflecting the
new namespace

Why top/ps inside a container show container-only
stats

bash

The program to run as PID 1 inside
the namespaces

Your application''s ENTRYPOINT', 3)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-6-4', 'mod-6', 'cgroups: Resource Limits', '### cgroups: Resource Limits

```bash
ls /sys/fs/cgroup/             # Your shell''s cgroup
cat /proc/$$/cgroup            # Run a container with explicit limits
docker run -d --name limited --memory=256m --cpus=0.5 nginx # See live resource usage
docker stats limited --no-stream # Find the cgroup memory limit file
docker inspect limited --format ''{{.Id}}'' # cat /sys/fs/cgroup/system.slice/docker-[id].scope/memory.max
```

KUBERNE
TES
CONNECTI
ON

When you set resources.limits.memory: 512Mi in a pod spec, kubelet writes to a cgroup
memory.max file. If the process exceeds it, the kernel''s OOM killer sends SIGKILL. Exit
code 137 = 128 + 9 (SIGKILL). That is what OOMKilled means.', 4)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-6-5', 'mod-6', 'Writing Better Dockerfiles', '### Writing Better Dockerfiles

```dockerfile
FROM eclipse-temurin:17-jre-jammy
# Module 2: create a non-root user
RUN groupadd -g 1001 appgroup && \\
useradd -u 1001 -g appgroup -m appuser
```

# Module 1: standard filesystem layout
WORKDIR /app
COPY --chown=appuser:appgroup app.jar .
# Module 2: switch to non-root before the process starts
USER appuser
# Module 4: the app listens on this port
EXPOSE 8080
# Module 3: becomes PID 1 inside the container''s PID namespace
ENTRYPOINT ["java", "-jar", "app.jar"]', 5)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-6-6', 'mod-6', 'Kubernetes Primitives Table', '### Kubernetes Primitives Table

| Concept | Equivalent | Scope | What it is |
|---|---|---|---|
| Pod | Group of processes sharing a network namespace | Module 6 | The smallest deployable unit in Kubernetes |
| Container | Process + namespaces + cgroup limits | Modules 3 and 6 | Isolated application environment |
| resources.limits.memory | cgroup memory.max | Module 6 | Maximum memory a container can use |
| resources.limits.cpu | cgroup cpu.cfs_quota_us | Module 6 | Maximum CPU cycles a container can use |', 6)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-6-7', 'mod-6', 'Mini Project: container_forensics.sh', '### Mini Project: container_forensics.sh

```bash
set -euo pipefail
CONTAINER="${1:-}"
if [[ -z "$CONTAINER" ]]; then
echo "Usage: $0 <container-name>"
exit 1
fi
if ! docker inspect "$CONTAINER" > /dev/null 2>&1; then
echo "ERROR: No container named ''$CONTAINER'' found"
exit 1
fi
echo "============================"
echo " Container Forensics: $CONTAINER"
echo "============================"
echo ''''
echo ''--- Host PID ---''
PID=$(docker inspect "$CONTAINER" --format ''{{.State.Pid}}'')
echo "Host PID: $PID"
echo ''''
echo ''--- Process Status (/proc) ---''
if [[ -d "/proc/$PID" ]]; then
cat "/proc/$PID/status" | head -5
else
echo ''Process not found (container may not be running)''
fi
echo ''''
echo ''--- Memory Usage ---''
docker stats "$CONTAINER" --no-stream --format ''table
{{.Name}}\\t{{.MemUsage}}\\t{{.MemPerc}}\\t{{.CPUPerc}}''
echo ''''
echo ''--- Running As ---''
WHOAMI=$(docker exec "$CONTAINER" whoami 2>/dev/null || echo ''unable to
determine'')
echo "User: $WHOAMI"
echo ''''
echo ''--- Last 10 Log Lines ---''
docker logs --tail 10 "$CONTAINER"
echo ''''
echo ''--- OOM Killed History ---''
OOMKILLED=$(docker inspect "$CONTAINER" --format ''{{.State.OOMKilled}}'')
if [[ "$OOMKILLED" == ''true'' ]]; then
echo ''WARNING: This container has been OOMKilled''
else
echo ''OOMKilled: false''
fi
```', 7)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-7-1', 'mod-7', 'Variables and Quoting', '### Variables and Quoting

NAME="Mandisi"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
COUNT=$((1 + 2))
echo "Hello, $NAME"            # Command substitution # Expands variable — use almost always
echo ''Hello, $NAME''            # Arithmetic — double parentheses # Literal text, NO expansion

# The classic unquoted bug
FILE="my file.txt"
rm $FILE
# WRONG: tries to remove ''my'' and ''file.txt'' separately
rm "$FILE" # CORRECT: removes ''my file.txt''', 1)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-7-2', 'mod-7', 'Conditionals — Full Reference', '### Conditionals — Full Reference

```bash
[ "$A" -gt "$B" ]
# greater than
[ "$A" -lt "$B" ]
# less than
[ "$A" -eq "$B" ]
# equal
[ "$A" -ne "$B" ]
# not equal
# String tests
[ -z "$A" ]
[ -n "$A" ]
```

```bash
# string is empty
# string is not empty
```

```bash
# File tests
[ -f "$FILE" ]                 # exists and is a regular file
[ -d "$DIR" ]                  # exists and is a directory
[ -x "$FILE" ]                 # exists and is executable
[ -s "$FILE" ]                 # exists and is not empty
```

```bash
# [[ ]] vs [ ] — prefer [[ ]] in bash scripts
# [[ ]] supports &&/|| inside brackets and regex with =~
```', 2)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-7-3', 'mod-7', 'Loops — All Three Forms', '### Loops — All Three Forms

for SERVICE in nginx postgresql redis; do
echo "Checking $SERVICE"
done

# for — iterate over files
for FILE in /var/log/*.log; do
du -sh "$FILE"
done
# while — loop while a condition is true
COUNT=0
while [ "$COUNT" -lt 5 ]; do
echo "Count: $COUNT"
COUNT=$((COUNT + 1))
done
# while read — process a file line by line
while IFS= read -r LINE; do
echo "Line: $LINE"
done < /etc/hosts', 3)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-7-4', 'mod-7', 'Functions', '### Functions

```bash
echo "[$(date ''+%Y-%m-%d %H:%M:%S'')] $1" # local = scoped to this function only
systemctl is-active --quiet "$SERVICE" # To return data (not just exit code), use echo and capture:
```', 4)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-7-5', 'mod-7', 'Error Handling', '### Error Handling

```bash
set -euo pipefail
# -e : exit immediately if any command returns non-zero
# -u : exit if you reference an unset variable
# -o pipefail : fail if ANY command in a pipeline fails
#
(without this, ''cat missing | grep x'' exits 0)
# Trap errors for cleanup
TEMP_FILE=$(mktemp)
cleanup() {
rm -f "$TEMP_FILE"
echo ''Cleaned up''
}
```

trap cleanup EXIT

PROFESSI
ONAL
HABIT

```bash
# Runs on any exit — success, failure, or Ctrl+C
# Exception: kill -9 bypasses traps (kernel handles it)
```

```bash
Start every production script with set -euo pipefail and a trap cleanup EXIT. These two
habits catch the most common script failures and guarantee cleanup happens even
when things go wrong.
```', 5)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-7-6', 'mod-7', 'Text Processing Pipelines', '### Text Processing Pipelines

```bash
awk ''{print $1}'' access.log | sort | uniq -c | sort -rn | head -10
# Find which users have the most failed SSH attempts
grep ''Failed password'' /var/log/auth.log | awk ''{print $(NF-3)}'' | sort | uniq -c
| sort -rn | head -5
# Replace a config value across multiple files
sed -i ''s/db.host=localhost/db.host=db.internal/'' /etc/myapp/*.conf
# sort must come before uniq -c
# uniq only collapses ADJACENT duplicate lines
# sort groups identical lines first so uniq -c can count them correctly
```', 6)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-7-7', 'mod-7', 'Environment Variables', '### Environment Variables

```bash
set -a                         # Require a variable (fail loudly if not set)
set +a                         # Load from .env file
```', 7)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-7-8', 'mod-7', 'Cron', '### Cron

crontab -e
# Syntax: minute hour day month weekday command
0
2
* * *
/home/mandisi/scripts/backup.sh
*/15
*
* * *
/home/mandisi/scripts/health_check.sh
0
9
* * 1
/home/mandisi/scripts/weekly_report.sh

```bash
# Daily 2am
# Every 15 mins
# Monday 9am
```

# Always use full paths in cron — $PATH is minimal
# Capture output for debugging:
*/5 * * * * /home/mandisi/scripts/check.sh >> /home/mandisi/logs/cron.log 2>&1', 8)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

INSERT INTO sections (id, module_id, title, content_md, order_index) VALUES
('sec-7-9', 'mod-7', 'Capstone: system_report.sh', '### Capstone: system_report.sh

```bash
set -euo pipefail
REPORT_FILE="/tmp/system_report_$(date +%Y%m%d_%H%M%S).txt"
log_section() { echo ''''; echo "--- $1 ---"; }
{
echo ''====================================''
echo " System Report — $(hostname)"
echo " Generated: $(date)"
echo ''====================================''
log_section ''Module 1: Filesystem''
df -h /
log_section ''Module 2: Current User''
whoami; groups
log_section ''Module 3: Top Processes''
ps aux --sort=-%mem | head -5
log_section ''Module 4: Network''
hostname -I
ss -tulnp | head -10
log_section ''Module 5: Failed Services''
systemctl list-units --type=service --state=failed --no-pager
log_section ''Module 6: Docker Containers''
if command -v docker > /dev/null; then
docker ps --format ''table {{.Names}}\\t{{.Status}}\\t{{.Image}}''
else
echo ''Docker not installed''
fi
} | tee "$REPORT_FILE"
echo ""
echo "Report saved to: $REPORT_FILE"
```

Resources
Interactive Learning
•​

Over The Wire: Bandit — Linux command line wargame, starts from zero

```bash
•​
•​
•​
•​
```

Linux Journey (linuxjourney.com) — structured free curriculum
Killercoda — browser-based Linux and Kubernetes labs
explainshell.com — paste any command to see each part explained
tldr.sh — simplified man pages with practical examples

Books
•​
•​

The Linux Command Line by William Shotts — free online at linuxcommand.org
How Linux Works by Brian Ward — excellent for understanding internals

```bash
Kubernetes Preparation
•​
•​
•​
```

Kubernetes the Hard Way (Kelsey Hightower) — sets up K8s from scratch using Linux
primitives
Killercoda CKA/CKAD labs — hands-on exam preparation
Linux Foundation LFS101x — free Introduction to Linux on edX', 9)
ON DUPLICATE KEY UPDATE title=VALUES(title), content_md=VALUES(content_md);

-- 3. Quiz Questions
INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-1-1', 'sec-1-1', 'What is the core philosophy of the Linux operating system regarding resources?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Everything is a process"}, {"id": "b", "text": "Everything is a file"}, {"id": "c", "text": "Everything is a socket"}, {"id": "d", "text": "Everything is an object"}]', 'b', 'In Linux, everything including hard drives, process info, sockets, and hardware devices is represented as a file in the filesystem.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-1-2', 'sec-1-1', 'Which of the following is NOT represented as a file in the Linux directory tree?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "A network socket"}, {"id": "b", "text": "A running process''s state"}, {"id": "c", "text": "An external USB drive"}, {"id": "d", "text": "A CPU hardware instruction register"}]', 'd', 'CPU registers are low-level processor hardware and are not exposed directly as files in the virtual filesystem.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-2-1', 'sec-1-2', 'Which directory contains system-wide configuration files in Linux?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "/var"}, {"id": "b", "text": "/home"}, {"id": "c", "text": "/etc"}, {"id": "d", "text": "/proc"}]', 'c', '/etc is the central location for configuration files of all system services and applications.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-2-2', 'sec-1-2', 'What is the difference between / (root) and /root?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "They are exactly the same directory"}, {"id": "b", "text": "/root is the system root directory, / is the root user''s home"}, {"id": "c", "text": "/ is the system root directory, /root is the root user''s home"}, {"id": "d", "text": "/root is for system binaries, / is for config files"}]', 'c', '/ is the top level of the entire file system tree, while /root is the home directory specifically for the administrative root user.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-3-1', 'sec-1-3', 'Which command outputs the absolute path of your current working directory?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "ls"}, {"id": "b", "text": "pwd"}, {"id": "c", "text": "cd -"}, {"id": "d", "text": "whoami"}]', 'b', 'pwd stands for Print Working Directory and outputs the complete absolute path of your current position.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-3-2', 'sec-1-3', 'What does the command ''cd -'' do?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Moves up one level in the directory tree"}, {"id": "b", "text": "Moves to the home directory"}, {"id": "c", "text": "Returns to the previous working directory"}, {"id": "d", "text": "Clears the terminal screen"}]', 'c', 'The hyphen option for cd changes the working directory to the previously visited directory.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-4-1', 'sec-1-4', 'Which command is best suited to view a very large log file interactively with scrolling capability?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "cat"}, {"id": "b", "text": "head"}, {"id": "c", "text": "less"}, {"id": "d", "text": "tail"}]', 'c', 'less opens the file in a paginated mode, allowing you to scroll forwards and backwards without loading the entire file into memory.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-4-2', 'sec-1-4', 'How do you view updates to a log file in real-time as they are appended?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "tail -f <file>"}, {"id": "b", "text": "cat <file> | follow"}, {"id": "c", "text": "less +g <file>"}, {"id": "d", "text": "head -n 20 <file>"}]', 'a', 'The -f option of tail (follow) keeps the file open and prints new lines as they are written by other processes.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-5-1', 'sec-1-5', 'Which command searches for a file named ''nginx.conf'' starting from the root directory?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "which nginx.conf"}, {"id": "b", "text": "find / -name ''nginx.conf''"}, {"id": "c", "text": "search ''nginx.conf''"}, {"id": "d", "text": "locate -all ''nginx.conf''"}]', 'b', 'find / -name ''nginx.conf'' executes a recursive directory search starting at / looking for names matching the pattern.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-5-2', 'sec-1-5', 'What does the command ''which python3'' return?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "The version of python3 installed"}, {"id": "b", "text": "The full path to the python3 binary"}, {"id": "c", "text": "A list of all python processes running"}, {"id": "d", "text": "The help manual for python3"}]', 'b', 'which searches the directories in the user''s PATH environment variable and returns the path to the executable that would be run.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-6-1', 'sec-1-6', 'Which virtual directory exposes real-time hardware and process details directly from the Linux kernel?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "/etc"}, {"id": "b", "text": "/var"}, {"id": "c", "text": "/proc"}, {"id": "d", "text": "/usr"}]', 'c', '/proc is a virtual, in-memory filesystem that represents the current kernel state and process list.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-6-2', 'sec-1-6', 'Which command is commonly used to inspect network interfaces and IP addresses on modern Linux systems?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "ip addr"}, {"id": "b", "text": "netstat -r"}, {"id": "c", "text": "ifconfig -d"}, {"id": "d", "text": "network-show"}]', 'a', '''ip addr'' (part of iproute2) is the standard modern utility for viewing and configuring network interfaces.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-7-1', 'sec-1-7', 'How do you view hidden files (files starting with a period) in a directory listing?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "ls -h"}, {"id": "b", "text": "ls -la"}, {"id": "c", "text": "ls -x"}, {"id": "d", "text": "ls --hidden"}]', 'b', 'The -a (all) flag for ls includes hidden files, and -l is for long formatting.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-7-2', 'sec-1-7', 'What does running a command with ''sudo'' mean?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Run the command in secure mode"}, {"id": "b", "text": "Run the command with temporary administrator/root privileges"}, {"id": "c", "text": "Run the command in the background"}, {"id": "d", "text": "Run a system diagnostic check"}]', 'b', 'sudo stands for Superuser Do and runs the target command with root privileges.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-8-1', 'sec-1-8', 'What does the shebang line ''#!/usr/bin/env bash'' at the top of a script do?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "It is a comment describing the script"}, {"id": "b", "text": "It tells the system to use the bash shell interpreter found in the system PATH to run the script"}, {"id": "c", "text": "It compiles the script before running"}, {"id": "d", "text": "It grants execute permissions to the script"}]', 'b', 'The shebang tells the operating system''s loader which interpreter to use to execute the text file''s contents.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-8-2', 'sec-1-8', 'What does ''du -sh /var/log/*'' do?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Deletes logs under /var/log"}, {"id": "b", "text": "Displays disk usage for each item in /var/log in human-readable summary form"}, {"id": "c", "text": "Lists files sorted by date"}, {"id": "d", "text": "Compresses old log files"}]', 'b', 'du stands for Disk Usage. The -s flag summarizes the usage of the directory, and -h displays sizes in KB, MB, or GB.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-9-1', 'sec-1-9', 'When you execute a shell inside a Kubernetes pod using ''kubectl exec'', where do you land?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "On the host Kubernetes node''s filesystem"}, {"id": "b", "text": "Inside the isolated container''s virtual Linux filesystem"}, {"id": "c", "text": "In the Kubernetes control plane database"}, {"id": "d", "text": "On the client local PC shell"}]', 'b', 'kubectl exec connects you to the container runtime namespaces, spawning a process in the container''s isolated mount namespace.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-1-9-2', 'sec-1-9', 'Where are service configurations typically located inside a running Docker container?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "/home/config"}, {"id": "b", "text": "/etc/"}, {"id": "c", "text": "/sys/class"}, {"id": "d", "text": "/boot/"}]', 'b', 'Just like standard Linux, containers adhere to the Filesystem Hierarchy Standard, placing config in /etc.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-1-1', 'sec-2-1', 'What three permission categories are assigned to every file and folder in Linux?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Root, User, System"}, {"id": "b", "text": "Owner (User), Group, Others (World)"}, {"id": "c", "text": "Read, Write, Execute"}, {"id": "d", "text": "Admin, Staff, Guest"}]', 'b', 'Standard Linux file permissions are divided into User (owner), Group, and Others.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-1-2', 'sec-2-1', 'What happens if a user who is neither the owner nor in the group attempts to modify a file?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "The owner''s permissions are applied"}, {"id": "b", "text": "The group''s permissions are applied"}, {"id": "c", "text": "The others (world) permissions are applied"}, {"id": "d", "text": "The file is locked permanently"}]', 'c', 'If the user matches neither user nor group ownership, the system falls back to evaluating the ''others'' permission bits.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-2-1', 'sec-2-2', 'What does a permission string starting with ''d'' indicate?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "The file is a device file"}, {"id": "b", "text": "The entry is a directory"}, {"id": "c", "text": "The file is deleted"}, {"id": "d", "text": "Write permission is disabled"}]', 'b', 'The first character of the permission string represents the file type. A ''d'' means directory, ''-'' means file, and ''l'' means symlink.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-2-2', 'sec-2-2', 'Decode the permission string ''-rwxr-xr--''. What can members of the file''s group do?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Read, write, and execute the file"}, {"id": "b", "text": "Read and execute the file"}, {"id": "c", "text": "Read only"}, {"id": "d", "text": "Write and execute the file"}]', 'b', 'The string breaks down into: type ''-'', owner ''rwx'' (read/write/execute), group ''r-x'' (read/execute), and others ''r--'' (read only).', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-3-1', 'sec-2-3', 'Which numeric mode grants read/write permissions to the owner, and read-only to group and others?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "chmod 755"}, {"id": "b", "text": "chmod 644"}, {"id": "c", "text": "chmod 600"}, {"id": "d", "text": "chmod 700"}]', 'b', '644 translates to: User = 4(r)+2(w) = 6; Group = 4(r) = 4; Others = 4(r) = 4.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-3-2', 'sec-2-3', 'Which command adds execute permission specifically to the owner (user) of a script?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "chmod +x script.sh"}, {"id": "b", "text": "chmod u+x script.sh"}, {"id": "c", "text": "chmod o+x script.sh"}, {"id": "d", "text": "chmod a+x script.sh"}]', 'b', 'u+x adds execute permission to the owner (user) only. ''+x'' or ''a+x'' adds it to all user classes.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-4-1', 'sec-2-4', 'Which command recursively changes the owner to ''alice'' and group to ''admins'' for all files inside ''/app''?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "chown alice:admins /app"}, {"id": "b", "text": "chown -R alice:admins /app"}, {"id": "c", "text": "chmod -R alice:admins /app"}, {"id": "d", "text": "chgrp -R admins alice /app"}]', 'b', 'chown changes file ownership. The -R flag applies changes recursively to all subfolders and files.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-4-2', 'sec-2-4', 'What does the command ''chown :developers file.txt'' do?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Changes both owner and group to developers"}, {"id": "b", "text": "Changes only the group ownership to developers"}, {"id": "c", "text": "Changes the owner to developers"}, {"id": "d", "text": "Creates a new group named developers"}]', 'b', 'When the colon prefix is used in chown (e.g. :group), only the group ownership is modified.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-5-1', 'sec-2-5', 'Where is the list of all users on a Linux system stored?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "/etc/shadow"}, {"id": "b", "text": "/etc/passwd"}, {"id": "c", "text": "/etc/users"}, {"id": "d", "text": "/var/users"}]', 'b', '/etc/passwd contains account information like username, UID, GID, home directory, and default shell.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-5-2', 'sec-2-5', 'Why is it important to include the ''-a'' flag when adding a user to a group using ''usermod -aG''?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "It stands for administrator privileges"}, {"id": "b", "text": "It appends the group, preventing the user from being removed from their other groups"}, {"id": "c", "text": "It creates the group if it doesn''t exist"}, {"id": "d", "text": "It activates the group immediately"}]', 'b', 'Without the -a (append) flag, usermod will remove the user from any groups not listed in the command.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-6-1', 'sec-2-6', 'What permissions are strictly required by the SSH daemon on a private key file (e.g., id_rsa) before it can be used?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "chmod 777"}, {"id": "b", "text": "chmod 644"}, {"id": "c", "text": "chmod 600"}, {"id": "d", "text": "chmod 755"}]', 'c', 'SSH requires that private keys are readable only by the owner (600). If others have access, SSH rejects the key.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-6-2', 'sec-2-6', 'What permission level is standard for the ~/.ssh directory itself?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "chmod 700"}, {"id": "b", "text": "chmod 755"}, {"id": "c", "text": "chmod 600"}, {"id": "d", "text": "chmod 777"}]', 'a', 'The ~/.ssh directory must have user read/write/execute permissions (700) and restrict group/others completely.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-7-1', 'sec-2-7', 'What symbolic permission matches the octal permission number 5?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "rw-"}, {"id": "b", "text": "r--"}, {"id": "c", "text": "r-x"}, {"id": "d", "text": "-wx"}]', 'c', '5 is calculated as 4 (read) + 1 (execute) = r-x.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-7-2', 'sec-2-7', 'If a directory has permissions ''drwxr-xr-x'', who has write permission to create files inside it?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Only the owner (user)"}, {"id": "b", "text": "The owner and group members"}, {"id": "c", "text": "Everyone"}, {"id": "d", "text": "Nobody"}]', 'a', '''rwx'' is the owner''s permission block, including ''w'' (write). Group and others have ''r-x'' (no write).', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-8-1', 'sec-2-8', 'How do you find all world-writable files in the ''/etc'' folder using the ''find'' command?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "find /etc -perm 777"}, {"id": "b", "text": "find /etc -perm -o+w"}, {"id": "c", "text": "find /etc -name ''*writable*''"}, {"id": "d", "text": "find /etc -perm -a+w"}]', 'b', '-perm -o+w instructs find to check if the ''others'' write bit is set, regardless of the user/group bits.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-8-2', 'sec-2-8', 'What does the shell parameter ''set -euo pipefail'' achieve in a script?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Enables debug logging"}, {"id": "b", "text": "Instructs the script to exit immediately on errors, undefined variables, and pipe failures"}, {"id": "c", "text": "Grants root permissions during runtime"}, {"id": "d", "text": "Optimizes performance of bash loops"}]', 'b', 'This flag combination enforces safe programming practices by terminating scripts immediately when errors occur.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-9-1', 'sec-2-9', 'How does Kubernetes reference user accounts on the host Linux system?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "By the string username directly"}, {"id": "b", "text": "By the numeric User ID (UID) defined in securityContext"}, {"id": "c", "text": "Via Kubernetes certificates"}, {"id": "d", "text": "Kubernetes bypasses user ID security completely"}]', 'b', 'Kubernetes containers run processes using Linux kernel primitives, relying on numeric UIDs/GIDs in securityContext.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-2-9-2', 'sec-2-9', 'Why is running a container service as root (UID 0) considered a security risk?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "It uses double the memory"}, {"id": "b", "text": "If the container is compromised, the attacker has root privileges on the host kernel"}, {"id": "c", "text": "Root containers cannot connect to the internet"}, {"id": "d", "text": "Kubernetes will refuse to schedule the pod"}]', 'b', 'A container shares the host''s kernel. If a process running as root escapes the namespace limits, it has root access to the entire host.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-3-1-1', 'sec-3-1', 'What is a process in Linux?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "A file stored on the disk"}, {"id": "b", "text": "A running instance of a program in memory"}, {"id": "c", "text": "A network connection"}, {"id": "d", "text": "A kernel driver"}]', 'b', 'A process is a dynamic entity representing an active, running program allocated with system resources.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-3-1-2', 'sec-3-1', 'What unique ID is assigned to every process by the Linux kernel?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "UID"}, {"id": "b", "text": "GID"}, {"id": "c", "text": "PID"}, {"id": "d", "text": "UUID"}]', 'c', 'PID stands for Process Identifier, a unique integer tracking active processes.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-3-2-1', 'sec-3-2', 'Which command column in ''ps aux'' represents the physical memory actually used by a process?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "VSZ"}, {"id": "b", "text": "RSS"}, {"id": "c", "text": "%MEM"}, {"id": "d", "text": "SIZE"}]', 'b', 'RSS (Resident Set Size) represents the actual non-swapped physical memory in kilobytes that a process is consuming.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-3-2-2', 'sec-3-2', 'How can you sort the process snapshot ''ps aux'' by memory usage, descending?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "ps aux --sort=mem"}, {"id": "b", "text": "ps aux --sort=-%mem"}, {"id": "c", "text": "ps aux | sort -m"}, {"id": "d", "text": "ps aux --memory"}]', 'b', 'The --sort option with a minus prefix sorts the result in descending order by the specified column.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-3-3-1', 'sec-3-3', 'Which signal number corresponds to SIGKILL, which forces immediate process termination?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Signal 15 (SIGTERM)"}, {"id": "b", "text": "Signal 9 (SIGKILL)"}, {"id": "c", "text": "Signal 1 (SIGHUP)"}, {"id": "d", "text": "Signal 2 (SIGINT)"}]', 'b', 'Signal 9 (SIGKILL) cannot be caught, blocked, or ignored, causing the kernel to terminate the process instantly.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-3-3-2', 'sec-3-3', 'Why is it best practice to send SIGTERM (15) before SIGKILL (9) to a service?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "SIGTERM executes faster"}, {"id": "b", "text": "SIGTERM allows the process to clean up connections, flush write buffers, and exit gracefully"}, {"id": "c", "text": "SIGKILL is only supported on administrative accounts"}, {"id": "d", "text": "SIGTERM is more compatible with Docker"}]', 'b', 'SIGTERM is a polite request to terminate, enabling the application''s signal handlers to release resources properly.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-3-4-1', 'sec-3-4', 'How do you start a command in the background from the shell?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Append an ampersand (&) to the command"}, {"id": "b", "text": "Prepend ''bg'' before the command"}, {"id": "c", "text": "Press Ctrl+Z after starting it"}, {"id": "d", "text": "Run it with ''nohup'' only"}]', 'a', 'Appending ''&'' to a command instructs the shell to spawn it asynchronously as a background job.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-3-4-2', 'sec-3-4', 'What keystroke sends SIGINT to the active foreground process, interrupting it?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Ctrl+Z"}, {"id": "b", "text": "Ctrl+C"}, {"id": "c", "text": "Ctrl+D"}, {"id": "d", "text": "Ctrl+\\\\"}]', 'b', 'Ctrl+C sends the interrupt signal (SIGINT, signal 2) to the running foreground process.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-3-5-1', 'sec-3-5', 'What does the special variable ''$$'' represent in a bash session?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "The last command''s exit code"}, {"id": "b", "text": "The PID of the current shell process"}, {"id": "c", "text": "The current user ID"}, {"id": "d", "text": "The background job count"}]', 'b', '''$$'' expands to the Process ID (PID) of the active shell instance.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-3-5-2', 'sec-3-5', 'Where does the kernel expose open file descriptors for process 1234?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "/sys/class/fd/1234/"}, {"id": "b", "text": "/var/run/1234/fd/"}, {"id": "c", "text": "/proc/1234/fd/"}, {"id": "d", "text": "/proc/fd/1234/"}]', 'c', '/proc/[PID]/fd/ is a virtual directory containing symlinks to all files, sockets, and pipes the process has open.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-3-6-1', 'sec-3-6', 'In the disk space extraction command ''df / | awk ''NR==2 {print $5}'''', what does ''NR==2'' mean?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Select the second column"}, {"id": "b", "text": "Match the string ''NR'' twice"}, {"id": "c", "text": "Process only the second line (Record Number 2) of the output"}, {"id": "d", "text": "Divide the result by 2"}]', 'c', 'In awk, NR represents the Number of Records (lines) processed. NR==2 restricts action to the second line, which holds the filesystem data.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-3-6-2', 'sec-3-6', 'Which command utility displays live CPU core counts, load averages, and memory statistics in a friendly text UI?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "uptime"}, {"id": "b", "text": "free -h"}, {"id": "c", "text": "htop"}, {"id": "d", "text": "ps aux"}]', 'c', 'htop is an interactive system-monitor process-viewer that presents live gauges in a colorized terminal.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-3-7-1', 'sec-3-7', 'What underlying Linux mechanism enforces memory limit configurations in Kubernetes?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Systemd services"}, {"id": "b", "text": "Control Groups (cgroups)"}, {"id": "c", "text": "User namespaces"}, {"id": "d", "text": "Chroot jail limits"}]', 'b', 'Control Groups (cgroups) are the kernel primitive used to restrict resource usage (CPU, Memory, Disk I/O) of process groups.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-3-7-2', 'sec-3-7', 'When a container process is OOMKilled with exit code 137, what occurred?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "The app exited normally with a custom status"}, {"id": "b", "text": "The host ran out of disk space"}, {"id": "c", "text": "The process exceeded its memory limit, and the kernel terminated it via SIGKILL (9)"}, {"id": "d", "text": "The network connection timed out"}]', 'c', '137 is 128 + 9 (SIGKILL). The Linux kernel Out-Of-Memory (OOM) killer terminated the process because it exceeded cgroup limits.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-1-1', 'sec-4-1', 'What is loopback (interface ''lo'') used for?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Connecting to the router"}, {"id": "b", "text": "Internal process communication within the same machine (127.0.0.1)"}, {"id": "c", "text": "Bridging containers to ethernet"}, {"id": "d", "text": "Routing external traffic"}]', 'b', 'The loopback interface allows network services on a machine to connect to other services on the same host.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-1-2', 'sec-4-1', 'What constitutes a network socket connection?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "The MAC address alone"}, {"id": "b", "text": "A combination of IP address and Port number"}, {"id": "c", "text": "An SSH private key pairing"}, {"id": "d", "text": "A URL path routing rule"}]', 'b', 'A socket endpoint is defined by an IP address (location) and a port (application mapping).', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-2-1', 'sec-4-2', 'Which command flags are used with ''ss'' to list listening TCP/UDP ports numerically with process details?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "ss -a"}, {"id": "b", "text": "ss -tulnp"}, {"id": "c", "text": "ss -r"}, {"id": "d", "text": "ss --listen"}]', 'b', '-t (TCP), -u (UDP), -l (listening), -n (numeric ports), -p (processes).', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-2-2', 'sec-4-2', 'What is the difference between binding to 127.0.0.1 vs 0.0.0.0?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "127.0.0.1 listens on all interfaces, 0.0.0.0 is loopback"}, {"id": "b", "text": "127.0.0.1 is loopback only, 0.0.0.0 listens on all network interfaces"}, {"id": "c", "text": "They perform identical functions"}, {"id": "d", "text": "0.0.0.0 is faster"}]', 'b', '0.0.0.0 binds the socket to every available network interface, making it reachable from outside. 127.0.0.1 restricts connections to local clients only.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-3-1', 'sec-4-3', 'How do you test if a specific port (e.g. 5432) is open on a remote machine using netcat (''nc'')?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "nc -zv host 5432"}, {"id": "b", "text": "nc -ping host 5432"}, {"id": "c", "text": "nc -l 5432"}, {"id": "d", "text": "nc -c host 5432"}]', 'a', 'The -z flag stands for zero-I/O mode (scanning), and -v displays verbose results.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-3-2', 'sec-4-3', 'Which curl command prints only the HTTP response headers, suppressing the body?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "curl -b"}, {"id": "b", "text": "curl -I"}, {"id": "c", "text": "curl -v"}, {"id": "d", "text": "curl --body"}]', 'b', 'The -I flag (or --head) executes a HEAD request and outputs the response headers only.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-4-1', 'sec-4-4', 'Which file maps static hostnames to IP addresses locally, bypassing external DNS lookup?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "/etc/resolv.conf"}, {"id": "b", "text": "/etc/hosts"}, {"id": "c", "text": "/etc/dns.conf"}, {"id": "d", "text": "/var/hosts"}]', 'b', '/etc/hosts is verified first by the name resolution resolver libraries before sending requests to DNS servers.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-4-2', 'sec-4-4', 'Which file specifies the nameserver IPs that a Linux machine uses to query DNS?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "/etc/hosts"}, {"id": "b", "text": "/etc/resolv.conf"}, {"id": "c", "text": "/etc/nsswitch.conf"}, {"id": "d", "text": "/var/run/dns"}]', 'b', '/etc/resolv.conf is the resolver configuration file containing nameserver address directives.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-5-1', 'sec-4-5', 'How can you copy your local public key to a remote server''s authorized_keys file?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "scp key.pub host:/etc/"}, {"id": "b", "text": "ssh-copy-id user@host"}, {"id": "c", "text": "ssh-add user@host"}, {"id": "d", "text": "ssh-keygen -t user@host"}]', 'b', 'ssh-copy-id is a helper script that logs in and appends your ~/.ssh/id_rsa.pub to ~/.ssh/authorized_keys.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-5-2', 'sec-4-5', 'Where can you define shortcuts and credentials for SSH connections to avoid typing full paths/ports?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "/etc/ssh/sshd_config"}, {"id": "b", "text": "~/.ssh/config"}, {"id": "c", "text": "~/.ssh/authorized_keys"}, {"id": "d", "text": "/var/ssh/config"}]', 'b', '~/.ssh/config holds user SSH profile blocks (Host, HostName, User, IdentityFile, Port).', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-6-1', 'sec-4-6', 'What standard port is associated with the secure shell (SSH) daemon?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "80"}, {"id": "b", "text": "443"}, {"id": "c", "text": "22"}, {"id": "d", "text": "3306"}]', 'c', 'Port 22 is the registered port for standard SSH connections.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-6-2', 'sec-4-6', 'What default ports are mapped to PostgreSQL and MySQL databases respectively?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "MySQL = 5432, Postgres = 3306"}, {"id": "b", "text": "MySQL = 3306, Postgres = 5432"}, {"id": "c", "text": "MySQL = 8080, Postgres = 6379"}, {"id": "d", "text": "MySQL = 3306, Postgres = 6379"}]', 'b', 'MySQL listens on 3306, and PostgreSQL listens on 5432.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-7-1', 'sec-4-7', 'Which command yields the local IP address assigned to the host machine interface?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "hostname -I"}, {"id": "b", "text": "ping localhost"}, {"id": "c", "text": "dig +short localhost"}, {"id": "d", "text": "route -n"}]', 'a', 'hostname -I displays all network addresses assigned to active network interfaces.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-7-2', 'sec-4-7', 'In the pipeline ''dig google.com +short | head -1'', what is ''+short'' doing?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Executes the query fast"}, {"id": "b", "text": "Returns only the IP records, suppressing header headers and query comments"}, {"id": "c", "text": "Saves bandwidth"}, {"id": "d", "text": "Outputs the domain name only"}]', 'b', 'The +short option restricts dig to print only the answer records (e.g. IPs) without diagnostic blocks.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-8-1', 'sec-4-8', 'How do pods inside a Kubernetes cluster resolve another service''s address internally?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "By hardcoding the host''s /etc/hosts file"}, {"id": "b", "text": "Using a cluster DNS service (like CoreDNS) pointed to by /etc/resolv.conf in the pod"}, {"id": "c", "text": "Via IP multicast routing"}, {"id": "d", "text": "Kubernetes requires external public DNS servers"}]', 'b', 'Kubernetes auto-injects nameserver IPs pointing to the ClusterIP of CoreDNS/kube-dns into each pod''s /etc/resolv.conf.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-4-8-2', 'sec-4-8', 'What is the role of kube-proxy in Kubernetes networking?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "It acts as a container firewall"}, {"id": "b", "text": "It manages iptables rules (or IPVS) on each node to route Service ClusterIP traffic to pod endpoints"}, {"id": "c", "text": "It translates domains"}, {"id": "d", "text": "It exposes SSH ports"}]', 'b', 'kube-proxy updates packet filtering rules (e.g. iptables) so requests to virtual Service IPs map directly to actual backend pods.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-5-1-1', 'sec-5-1', 'What role does systemd play in a Linux system?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "It is a compiler tool"}, {"id": "b", "text": "It is PID 1, the initialization system that starts and manages services"}, {"id": "c", "text": "It is a network firewall tool"}, {"id": "d", "text": "It logs system metrics to disk"}]', 'b', 'systemd is the parent of all processes (PID 1), responsible for booting and maintaining user-space services.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-5-1-2', 'sec-5-1', 'Which central tool is used to query and control systemd logs?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "systemctl"}, {"id": "b", "text": "journalctl"}, {"id": "c", "text": "logctl"}, {"id": "d", "text": "syslog-view"}]', 'b', 'journalctl is the systemd utility used to query and parse logs generated by the systemd journal daemon.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-5-2-1', 'sec-5-2', 'What is the difference between enabling a service and starting a service using systemctl?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Starting sets it on boot, enabling runs it immediately"}, {"id": "b", "text": "Starting runs the service immediately, enabling configures it to launch automatically on boot"}, {"id": "c", "text": "They do exactly the same thing"}, {"id": "d", "text": "Enabling is only for system services, starting is for user programs"}]', 'b', 'start launches the process right now. enable creates symlinks to ensure it boots automatically when the system boots.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-5-2-2', 'sec-5-2', 'Which command activates a service immediately AND enables it to start on boot in a single line?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "systemctl start-enable nginx"}, {"id": "b", "text": "systemctl enable --now nginx"}, {"id": "c", "text": "systemctl boot --start nginx"}, {"id": "d", "text": "systemctl daemon-reload nginx"}]', 'b', 'The --now flag in combination with enable starts the service immediately while also enabling it for boot.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-5-3-1', 'sec-5-3', 'Which journalctl command is used to follow logs of a specific service (e.g., nginx) in real-time?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "journalctl -u nginx"}, {"id": "b", "text": "journalctl -u nginx -f"}, {"id": "c", "text": "journalctl -t nginx --follow"}, {"id": "d", "text": "journalctl --tail nginx"}]', 'b', 'The -u flag specifies the unit name, and the -f flag follows the log stream in real-time.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-5-3-2', 'sec-5-3', 'How can you view only logs that contain errors (-p err) for a service?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "journalctl -u service --error"}, {"id": "b", "text": "journalctl -p err -u service"}, {"id": "c", "text": "journalctl -p 0 -u service"}, {"id": "d", "text": "journalctl -u service | grep error"}]', 'b', 'The -p flag allows filtering logs by syslog priority levels, such as err, warning, info, or debug.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-5-4-1', 'sec-5-4', 'In which directory do system administrator-created systemd unit files reside?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "/lib/systemd/system/"}, {"id": "b", "text": "/etc/systemd/system/"}, {"id": "c", "text": "/var/systemd/system/"}, {"id": "d", "text": "/usr/local/systemd/"}]', 'b', 'Local configuration unit files are saved under /etc/systemd/system/, overriding package-managed files in /lib/systemd/system/.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-5-4-2', 'sec-5-4', 'Which command must be executed after adding or modifying a systemd unit file for changes to take effect?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "systemctl restart systemd"}, {"id": "b", "text": "systemctl daemon-reload"}, {"id": "c", "text": "systemctl update-units"}, {"id": "d", "text": "reboot"}]', 'b', 'daemon-reload forces systemd to scan the unit file directories and reload configuration descriptors.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-5-5-1', 'sec-5-5', 'What occurs when ''Restart=on-failure'' is set in a systemd unit file?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "The service restarts on any exit code (including 0)"}, {"id": "b", "text": "The service only restarts if it exits with a non-zero exit code or is killed by a signal"}, {"id": "c", "text": "The service restarts only if the system reboots"}, {"id": "d", "text": "The service is locked out of restarting"}]', 'b', 'on-failure restricts restarts to abnormal exits (non-zero return codes, timeouts, or killed signals).', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-5-5-2', 'sec-5-5', 'How can you test if your ''Restart=on-failure'' policy is working?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Stop the service normal via systemctl stop"}, {"id": "b", "text": "Kill the process ID (PID) using kill -9"}, {"id": "c", "text": "Disable the service"}, {"id": "d", "text": "Edit the config and run reload"}]', 'b', 'Force-killing a running process mocks an unexpected crash. Since it did not exit cleanly (exit code 0), systemd should trigger the restart.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-5-6-1', 'sec-5-6', 'Which systemctl command is used in scripts to silently check if a service is running?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "systemctl is-active --quiet <service>"}, {"id": "b", "text": "systemctl status <service>"}, {"id": "c", "text": "systemctl check <service>"}, {"id": "d", "text": "systemctl list-units"}]', 'a', 'is-active --quiet returns an exit status of 0 if running and non-zero if stopped, generating no console stdout.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-5-6-2', 'sec-5-6', 'Which command displays only systemd services that are currently in a failed state?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "systemctl status --failed"}, {"id": "b", "text": "systemctl list-units --type=service --state=failed"}, {"id": "c", "text": "journalctl -p err"}, {"id": "d", "text": "systemctl list-failed"}]', 'b', 'The list-units filter restricts output to services whose active state matches failed.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-5-7-1', 'sec-5-7', 'How do Kubernetes restart policies compare to systemd?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Kubernetes has no restart mechanisms"}, {"id": "b", "text": "They represent the same concept, with pod restartPolicy (Always, OnFailure) mapping to systemd Restart="}, {"id": "c", "text": "systemd manages pod scheduling"}, {"id": "d", "text": "Kubernetes only restarts on success"}]', 'b', 'Both systems use process monitoring: if a container/service process dies, the managing daemon (kubelet or systemd) respawns it based on policy.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-5-7-2', 'sec-5-7', 'How does ''kubectl logs'' retrieve output from a container process?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "By executing a database query"}, {"id": "b", "text": "By capturing the stdout and stderr streams of the container process"}, {"id": "c", "text": "By mounting /var/log/syslog"}, {"id": "d", "text": "By installing a logging agent inside the container"}]', 'b', 'Any standard application writing output to stdout/stderr is captured by the container runtime, which is read by kubelet and exposed via kubectl logs.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-1-1', 'sec-6-1', 'What represents a container at the host OS level?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "A full virtual machine running a separate kernel"}, {"id": "b", "text": "A standard Linux process restricted by namespaces and cgroups"}, {"id": "c", "text": "An emulator process"}, {"id": "d", "text": "A hardware partition"}]', 'b', 'Containers are simply isolated processes running directly on the host kernel, separated by namespaces and resource-capped by cgroups.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-1-2', 'sec-6-1', 'What underlying kernel capabilities are utilized to build a container?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Hypervisors and virtual CPU threads"}, {"id": "b", "text": "Namespaces and Control Groups (cgroups)"}, {"id": "c", "text": "SSH tunnels and firewalls"}, {"id": "d", "text": "Disk partitions and swap space"}]', 'b', 'Namespaces provide visibility isolation, while cgroups enforce hardware resource constraints.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-2-1', 'sec-6-2', 'Which namespace isolates the process lists, allowing a container process to become PID 1?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Network namespace"}, {"id": "b", "text": "PID namespace"}, {"id": "c", "text": "Mount namespace"}, {"id": "d", "text": "User namespace"}]', 'b', 'The PID namespace isolates the process tree, starting numbering from 1 inside the namespace, independent of the host process tree.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-2-2', 'sec-6-2', 'What is isolated by the UTS namespace?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "System time"}, {"id": "b", "text": "Hostname and NIS domain name"}, {"id": "c", "text": "User IDs"}, {"id": "d", "text": "Routing tables"}]', 'b', 'UTS stands for Unix Timesharing System, isolating hostnames and domain names.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-3-1', 'sec-6-3', 'Which command line utility is used to launch a command inside newly instantiated namespaces?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "nsenter"}, {"id": "b", "text": "unshare"}, {"id": "c", "text": "chroot"}, {"id": "d", "text": "docker run"}]', 'b', 'unshare disassociates parts of the process execution context, spawning a new namespace context for the command.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-3-2', 'sec-6-3', 'In the command ''unshare --pid --fork --mount-proc bash'', why is ''--mount-proc'' required?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "To increase memory limits"}, {"id": "b", "text": "To mount a fresh /proc reflecting the isolated PID namespace so tools like ''ps'' work correctly"}, {"id": "c", "text": "To mount an external hard drive"}, {"id": "d", "text": "To enable networking"}]', 'b', 'Without --mount-proc, commands like ''ps aux'' will read the host''s /proc instead of the new namespace''s process tree.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-4-1', 'sec-6-4', 'Where is the cgroup hierarchy exposed in the Linux file system?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "/var/run/cgroup/"}, {"id": "b", "text": "/sys/fs/cgroup/"}, {"id": "c", "text": "/proc/cgroup/"}, {"id": "d", "text": "/etc/cgroups/"}]', 'b', '/sys/fs/cgroup/ is the sysfs mount point representing the control group hierarchy.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-4-2', 'sec-6-4', 'Which cgroup file controls the maximum memory limit for a process slice?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "memory.max"}, {"id": "b", "text": "memory.limit"}, {"id": "c", "text": "mem.limit_in_bytes"}, {"id": "d", "text": "max_memory"}]', 'a', 'Under cgroups v2, ''memory.max'' defines the hard limit for memory consumption of the cgroup.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-5-1', 'sec-6-5', 'Why should a Dockerfile define a custom non-root user (e.g. ''USER appuser'')?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "To reduce container image size"}, {"id": "b", "text": "To enforce the principle of least privilege, preventing container breakout processes from possessing root access on the host"}, {"id": "c", "text": "To bypass port binding errors"}, {"id": "d", "text": "It is required by Docker syntax"}]', 'b', 'Running containers as root poses a risk: if a compromise occurs, the attacker is root, making privilege escalation easier.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-5-2', 'sec-6-5', 'What occurs when the JSON array form is used for ENTRYPOINT, e.g. ''ENTRYPOINT ["java", "-jar"]''?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "It runs inside a subshell wrapper"}, {"id": "b", "text": "It runs directly as PID 1, without a wrapping shell process"}, {"id": "c", "text": "It runs in background mode"}, {"id": "d", "text": "It compiles variables"}]', 'b', 'Using exec form (JSON) starts the process directly as PID 1. The shell form (plain string) wraps it in ''/bin/sh -c'', meaning signals are not forwarded.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-6-1', 'sec-6-6', 'What is the Linux equivalent of a Kubernetes Pod?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "A virtual machine host"}, {"id": "b", "text": "A group of processes sharing network and namespaces namespaces ( UTS, IPC )"}, {"id": "c", "text": "A systemd target unit"}, {"id": "d", "text": "An iptables router"}]', 'b', 'A Pod is a collection of containers that share namespaces (network, UTS, IPC), allowing them to talk to each other on localhost.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-6-2', 'sec-6-6', 'Which Linux system mechanism maps directly to Kubernetes Volume mounts?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "symbolic link (ln -s)"}, {"id": "b", "text": "Linux bind mounts (mount --bind)"}, {"id": "c", "text": "cgroup directory mount"}, {"id": "d", "text": "Network socket binding"}]', 'b', 'Volume mounts are implemented by mounting a host directory into the container''s isolated mount namespace.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-6-3', 'sec-6-6', 'Why do tools like ''kubectl top pods'' require metrics-server?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "It checks logs"}, {"id": "b", "text": "It queries cgroup memory/CPU usage counters compiled by kubelet on each node"}, {"id": "c", "text": "It checks node uptime"}, {"id": "d", "text": "It intercepts network ports"}]', 'b', 'metrics-server pulls resource usage metrics (which are generated from host cgroups stats) collected by the kubelet cadvisor.', 3)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-6-4', 'sec-6-6', 'What tool allows running processes inside the exact namespaces of a running container?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "unshare"}, {"id": "b", "text": "nsenter"}, {"id": "c", "text": "chroot"}, {"id": "d", "text": "systemctl"}]', 'b', 'nsenter (namespace enter) targets a process''s PID and launches a shell/command within its specific namespaces.', 4)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-7-1', 'sec-6-7', 'How do you fetch the host-side Process ID (PID) of a container process named ''webserver''?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "docker logs webserver"}, {"id": "b", "text": "docker inspect webserver --format ''{{.State.Pid}}''"}, {"id": "c", "text": "pgrep webserver"}, {"id": "d", "text": "cat /var/run/webserver.pid"}]', 'b', 'Docker tracks container processes. The inspect template returns the host-level PID mapping to the container''s main process.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-6-7-2', 'sec-6-7', 'What does a value of ''true'' for ''OOMKilled'' in docker inspect signify?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "The container exited successfully"}, {"id": "b", "text": "The container process was terminated by the kernel because it ran out of allocated memory"}, {"id": "c", "text": "The container had a disk space failure"}, {"id": "d", "text": "The CPU limit was hit"}]', 'b', 'This flag indicates that the cgroup memory limit was violated, triggering a kernel SIGKILL.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-1-1', 'sec-7-1', 'What is the difference between double quotes ("") and single quotes ('''') in bash?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Single quotes allow variable expansion, double quotes do not"}, {"id": "b", "text": "Double quotes expand variables and command substitutions, single quotes treat all characters literally"}, {"id": "c", "text": "Double quotes are faster than single quotes"}, {"id": "d", "text": "Single quotes compile commands"}]', 'b', 'Double quotes evaluate ''$var'' and ''$(cmd)''. Single quotes prevent all forms of shell expansion.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-1-2', 'sec-7-1', 'Why should variables containing filenames or paths almost always be enclosed in double quotes (e.g. "$FILE")?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "It turns the variable into a string type"}, {"id": "b", "text": "To prevent word splitting and globbing errors if the filename contains spaces or special characters"}, {"id": "c", "text": "To make it executable"}, {"id": "d", "text": "It is required by bash compilers"}]', 'b', 'If $FILE is ''my file.txt'', running ''rm $FILE'' resolves to ''rm my file.txt'' (two targets). ''rm "$FILE"'' resolves to one target.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-2-1', 'sec-7-2', 'Which bash operator checks if a string variable is empty?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "-n"}, {"id": "b", "text": "-z"}, {"id": "c", "text": "-e"}, {"id": "d", "text": "-d"}]', 'b', '-z returns true if the length of the string is zero.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-2-2', 'sec-7-2', 'What file test operator checks if a target path exists and is a regular file?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "-d"}, {"id": "b", "text": "-f"}, {"id": "c", "text": "-x"}, {"id": "d", "text": "-s"}]', 'b', '-f returns true if the path exists and is a standard regular file (not a directory or device).', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-3-1', 'sec-7-3', 'Which loop structure is designed to process a file line by line safely in bash?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "for LINE in $(cat file); do"}, {"id": "b", "text": "while IFS= read -r LINE; do ... done < file"}, {"id": "c", "text": "for each line in file; do"}, {"id": "d", "text": "loop lines file"}]', 'b', 'The ''while read'' loop combined with IFS= and read -r is the standard, safe way to read files line-by-line without word splitting.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-3-2', 'sec-7-3', 'What occurs in ''for FILE in /var/log/*.log'' if no log files exist?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "The loop skips and executes zero times"}, {"id": "b", "text": "The loop executes once with the literal string value ''/var/log/*.log''"}, {"id": "c", "text": "The script crashes immediately"}, {"id": "d", "text": "The directory is deleted"}]', 'b', 'In bash, if a wildcard (glob) matches nothing, it remains as a literal string unless the shell option ''nullglob'' is enabled.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-4-1', 'sec-7-4', 'How do you pass arguments into a bash function?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Define them in parentheses, e.g. function(arg1, arg2)"}, {"id": "b", "text": "Pass them as space-separated tokens after the function name, accessed via $1, $2 inside"}, {"id": "c", "text": "Declare global variables first"}, {"id": "d", "text": "Write them to a temporary file"}]', 'b', 'Bash functions do not define signature parameters. Arguments are passed positionally just like scripts and accessed via $1, $2, etc.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-4-2', 'sec-7-4', 'What is the purpose of the ''local'' keyword inside a bash function?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "It speeds up variables"}, {"id": "b", "text": "It scopes the variable specifically to the function, preventing pollution of the global namespace"}, {"id": "c", "text": "It saves the variable to the disk"}, {"id": "d", "text": "It locks the variable value"}]', 'b', 'By default, variables in bash functions are global. The local keyword restricts variable visibility to the active function stack.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-5-1', 'sec-7-5', 'What does setting ''set -e'' at the top of a script achieve?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Prints every command before execution"}, {"id": "b", "text": "Causes the script to exit immediately if any command returns a non-zero exit code"}, {"id": "c", "text": "Ignores all errors"}, {"id": "d", "text": "Turns on script encryption"}]', 'b', '-e (errexit) halts execution immediately upon command failures, preventing cascading error bugs.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-5-2', 'sec-7-5', 'What does a ''trap'' statement targeting ''EXIT'' do?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Intercepts exit keys"}, {"id": "b", "text": "Guarantees a clean-up handler runs whenever the shell exits (success, failure, or signals)"}, {"id": "c", "text": "Exits the script instantly"}, {"id": "d", "text": "Ignores terminations"}]', 'b', 'A trap on EXIT runs the registered command/function on normal exits, crashes, or user interrupts.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-6-1', 'sec-7-6', 'In the pipeline ''awk ''{print $1}'' access.log | sort | uniq -c | sort -rn'', why is ''sort'' required before ''uniq -c''?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "To filter empty values"}, {"id": "b", "text": "''uniq'' only identifies and collapses adjacent duplicate lines; sorting first groups identical lines together"}, {"id": "c", "text": "To index the output"}, {"id": "d", "text": "It is optional"}]', 'b', 'uniq expects identical records to be contiguous. Unsorted streams will return repeated blocks of the same record instead of aggregating.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-6-2', 'sec-7-6', 'Which sed command replaces the string ''localhost'' with ''db.internal'' in-place (-i) in the config file?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "sed -i ''s/localhost/db.internal/g'' app.conf"}, {"id": "b", "text": "sed -find ''localhost'' -replace ''db.internal'' app.conf"}, {"id": "c", "text": "sed -i ''replace localhost db.internal'' app.conf"}, {"id": "d", "text": "sed ''s/localhost/db.internal/'' app.conf"}]', 'a', 'The ''s/find/replace/g'' command substitutes occurrences, and -i saves changes directly to the file.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-7-1', 'sec-7-7', 'What value does ''DB_HOST="${DB_HOST:-localhost}"'' assign to DB_HOST if the environment variable DB_HOST is unset?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Null/empty string"}, {"id": "b", "text": "The string ''localhost''"}, {"id": "c", "text": "It throws an error"}, {"id": "d", "text": "The string ''${DB_HOST}''"}]', 'b', 'The parameter expansion ''${var:-default}'' returns the default value if the variable is null or unset.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-7-2', 'sec-7-7', 'What occurs if you call ''API_KEY="${API_KEY:?API_KEY must be set}"'' when API_KEY is unset?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Assigns empty value"}, {"id": "b", "text": "The script prints the error message to stderr and exits immediately with code 1"}, {"id": "c", "text": "A popup is shown"}, {"id": "d", "text": "Nothing, it is ignored"}]', 'b', 'The '':?'' parameter expansion behaves as an assertion, failing the script loudly if the parameter is empty.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-8-1', 'sec-7-8', 'What does the cron schedule ''*/15 * * * *'' mean?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Every 15 hours"}, {"id": "b", "text": "Every 15 minutes"}, {"id": "c", "text": "At 15:00 daily"}, {"id": "d", "text": "Every 15 days"}]', 'b', 'The first field of a crontab is the minutes. ''*/15'' means trigger every multiple of 15.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-8-2', 'sec-7-8', 'Why must you always specify absolute paths inside cron scripts?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Cron scripts run faster with absolute paths"}, {"id": "b", "text": "Cron executes with a minimal shell environment and a very limited default PATH variable"}, {"id": "c", "text": "Relative paths are blocked by Linux security"}, {"id": "d", "text": "It is a requirement of the cron editor"}]', 'b', 'Cron doesn''t load login environment profiles (~/.bashrc). Commands like ''node'' or ''python3'' may not be resolvable unless pathing is fully declared.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-9-1', 'sec-7-9', 'How can you group the output of multiple shell commands to pipe or redirect them together?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "Join them with commas"}, {"id": "b", "text": "Enclose them in curly braces: { cmd1; cmd2; }"}, {"id": "c", "text": "Use brackets: [ cmd1; cmd2; ]"}, {"id": "d", "text": "Write a separate file for each"}]', 'b', 'Curly braces group commands, allowing their aggregated stdout streams to be piped or redirected in one block.', 1)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO quiz_questions (id, section_id, question_text, question_type, options_json, correct_answer, explanation, order_index) VALUES
('qq-7-9-2', 'sec-7-9', 'What is the function of ''tee'' in the pipeline ''echo hello | tee file.txt''?', 'MULTIPLE_CHOICE', '[{"id": "a", "text": "It deletes the input"}, {"id": "b", "text": "It duplicates the output, writing to the file while simultaneously printing to stdout"}, {"id": "c", "text": "It compresses the text"}, {"id": "d", "text": "It checks spelling"}]', 'b', 'tee acts as a T-splitter in the stream, copying input to files and stdout.', 2)
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);


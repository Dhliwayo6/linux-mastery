-- V10__seed_projects_and_test_cases.sql

INSERT INTO projects (id, module_id, title, brief_md) VALUES
('proj-1', 'mod-1', 'sysinfo.sh', '## Your Task\n\nWrite a bash script called `sysinfo.sh` that outputs:\n\n1. The system hostname\n2. The OS name\n3. The top 5 largest items in `/var/log` sorted by size\n4. The current date\n\n## Requirements\n\n- Script must be executable\n- Use `#!/usr/bin/env bash` as the shebang\n- Each output should be labelled clearly'),

('proj-2', 'mod-2', 'permission_audit.sh', '## Your Task\n\nWrite a bash script called `permission_audit.sh` that performs a security/permissions audit of the environment:\n\n1. Output the current username and groups\n2. List home directory permissions\n3. List SSH directory permissions\n4. Find all executable `.sh` files in the home directory\n5. Check for world-writable files in `/etc`'),

('proj-3', 'mod-3', 'process_monitor.sh', '## Your Task\n\nWrite a process monitor bash script called `process_monitor.sh` that performs the following system checks:\n\n1. Show system load averages and CPU core count\n2. Show top 5 processes by CPU usage\n3. Show top 5 processes by Memory usage\n4. Verify if `bash` is running\n5. Show memory usage\n6. Check disk usage and warning if it exceeds 80%'),

('proj-4', 'mod-4', 'network_audit.sh', '## Your Task\n\nWrite a network auditing bash script called `network_audit.sh` that outputs:\n\n1. Machine IP address\n2. Active listening ports\n3. Internet connectivity check (ping 8.8.8.8)\n4. DNS resolution checks (google.com and github.com)\n5. Verify if SSH is listening on port 22\n6. Identify the configured nameserver'),

('proj-5', 'mod-5', 'service_manager.sh', '## Your Task\n\nWrite a system service manager script called `service_manager.sh` that takes a service name as a command-line argument and outputs:\n\n1. Active status of the service\n2. Enabled status of the service\n3. Last 20 log lines of the service\n4. Memory usage of the service\n\n## Requirements\n\n- Exits with code 1 if service name argument is not provided.'),

('proj-6', 'mod-6', 'container_forensics.sh', '## Your Task\n\nWrite a container forensics utility script called `container_forensics.sh` that takes a container name as a command-line argument and inspects the container:\n\n1. Host PID of the container\n2. Check status via `/proc` filesystem\n3. Container memory usage stats\n4. Container user account\n5. Last 10 log lines of the container\n6. Check if container has been OOMKilled\n\n## Requirements\n\n- Exits with code 1 if container name argument is not provided.'),

('proj-7', 'mod-7', 'system_report.sh', '## Your Task\n\nWrite a capstone bash script called `system_report.sh` that automates system documentation:\n\n1. Generate a comprehensive report containing: filesystem status, current user, top processes, network configuration, failed system services, and running Docker containers\n2. Save the report to a log file `/tmp/system_report_<timestamp>.txt` and output it to the console.');


INSERT INTO project_test_cases (id, project_id, description, weight, test_type, expected, order_index) VALUES
-- Module 1 Test Cases
('ptc-1-1', 'proj-1', 'Script exits with code 0', 2, 'EXIT_CODE', '0', 1),
('ptc-1-2', 'proj-1', 'Output contains Hostname:', 1, 'STDOUT_CONTAINS', 'Hostname:', 2),
('ptc-1-3', 'proj-1', 'Output contains OS:', 1, 'STDOUT_CONTAINS', 'OS:', 3),
('ptc-1-4', 'proj-1', 'Output contains Date:', 1, 'STDOUT_CONTAINS', 'Date:', 4),
('ptc-1-5', 'proj-1', 'Script uses hostname command', 2, 'COMMAND_USED', 'hostname', 5),
('ptc-1-6', 'proj-1', 'Script uses du command for disk info', 2, 'COMMAND_USED', 'du', 6),
('ptc-1-7', 'proj-1', 'Output sorted by size (largest first)', 3, 'STDOUT_MATCHES', 'sort.*-rh|sort.*-hr', 7),

-- Module 2 Test Cases
('ptc-2-1', 'proj-2', 'Script exits with code 0', 2, 'EXIT_CODE', '0', 1),
('ptc-2-2', 'proj-2', 'Output contains Current user label', 1, 'STDOUT_CONTAINS', '=== Current user ===', 2),
('ptc-2-3', 'proj-2', 'Output contains Groups label', 1, 'STDOUT_CONTAINS', '=== Groups ===', 3),
('ptc-2-4', 'proj-2', 'Output contains Home directory permissions label', 1, 'STDOUT_CONTAINS', '=== Home directory permissions ===', 4),
('ptc-2-5', 'proj-2', 'Output contains SSH directory permissions label', 1, 'STDOUT_CONTAINS', '=== SSH directory permissions ===', 5),
('ptc-2-6', 'proj-2', 'Output contains Executable .sh files label', 1, 'STDOUT_CONTAINS', '=== Executable .sh files in home directory ===', 6),
('ptc-2-7', 'proj-2', 'Output contains World-writable files label', 1, 'STDOUT_CONTAINS', '=== World-writable files in /etc (security check) ===', 7),
('ptc-2-8', 'proj-2', 'Script uses find command', 2, 'COMMAND_USED', 'find', 8),

-- Module 3 Test Cases
('ptc-3-1', 'proj-3', 'Script exits with code 0', 2, 'EXIT_CODE', '0', 1),
('ptc-3-2', 'proj-3', 'Output contains Process Health Monitor header', 1, 'STDOUT_CONTAINS', 'Process Health Monitor', 2),
('ptc-3-3', 'proj-3', 'Output contains Load Averages label', 1, 'STDOUT_CONTAINS', '--- Load Averages ---', 3),
('ptc-3-4', 'proj-3', 'Output contains CPU Cores label', 1, 'STDOUT_CONTAINS', '--- CPU Cores ---', 4),
('ptc-3-5', 'proj-3', 'Output contains Top 5 Processes by CPU label', 1, 'STDOUT_CONTAINS', '--- Top 5 Processes by CPU ---', 5),
('ptc-3-6', 'proj-3', 'Output contains Top 5 Processes by Memory label', 1, 'STDOUT_CONTAINS', '--- Top 5 Processes by Memory ---', 6),
('ptc-3-7', 'proj-3', 'Output contains Memory Usage label', 1, 'STDOUT_CONTAINS', '--- Memory Usage ---', 7),
('ptc-3-8', 'proj-3', 'Output contains Disk Usage Check label', 1, 'STDOUT_CONTAINS', '--- Disk Usage Check ---', 8),
('ptc-3-9', 'proj-3', 'Script uses ps command', 2, 'COMMAND_USED', 'ps', 9),

-- Module 4 Test Cases
('ptc-4-1', 'proj-4', 'Script exits with code 0', 2, 'EXIT_CODE', '0', 1),
('ptc-4-2', 'proj-4', 'Output contains Network Audit header', 1, 'STDOUT_CONTAINS', 'Network Audit', 2),
('ptc-4-3', 'proj-4', 'Output contains Machine IP Address label', 1, 'STDOUT_CONTAINS', '--- Machine IP Address ---', 3),
('ptc-4-4', 'proj-4', 'Output contains Listening Ports label', 1, 'STDOUT_CONTAINS', '--- Listening Ports ---', 4),
('ptc-4-5', 'proj-4', 'Output contains Internet Connectivity Test label', 2, 'STDOUT_CONTAINS', '--- Internet Connectivity Test ---', 5),
('ptc-4-6', 'proj-4', 'Output contains DNS Resolution Check label', 2, 'STDOUT_CONTAINS', '--- DNS Resolution Check ---', 6),
('ptc-4-7', 'proj-4', 'Script uses ss command', 2, 'COMMAND_USED', 'ss', 7),
('ptc-4-8', 'proj-4', 'Script uses dig command', 2, 'COMMAND_USED', 'dig', 8),

-- Module 5 Test Cases (Expected exit code 1 when run without arguments)
('ptc-5-1', 'proj-5', 'Script exits with code 1 without arguments', 2, 'EXIT_CODE', '1', 1),
('ptc-5-2', 'proj-5', 'Output contains Usage info', 2, 'STDOUT_CONTAINS', 'Usage:', 2),
('ptc-5-3', 'proj-5', 'Script uses systemctl command', 2, 'COMMAND_USED', 'systemctl', 3),
('ptc-5-4', 'proj-5', 'Script uses journalctl command', 2, 'COMMAND_USED', 'journalctl', 4),
('ptc-5-5', 'proj-5', 'Script checks if service is active', 1, 'COMMAND_USED', 'is-active', 5),
('ptc-5-6', 'proj-5', 'Script checks if service is enabled', 1, 'COMMAND_USED', 'is-enabled', 6),

-- Module 6 Test Cases (Expected exit code 1 when run without arguments)
('ptc-6-1', 'proj-6', 'Script exits with code 1 without arguments', 2, 'EXIT_CODE', '1', 1),
('ptc-6-2', 'proj-6', 'Output contains Usage info', 2, 'STDOUT_CONTAINS', 'Usage:', 2),
('ptc-6-3', 'proj-6', 'Script uses docker inspect command', 2, 'COMMAND_USED', 'docker inspect', 3),
('ptc-6-4', 'proj-6', 'Script uses docker stats command', 2, 'COMMAND_USED', 'docker stats', 4),
('ptc-6-5', 'proj-6', 'Script uses docker logs command', 2, 'COMMAND_USED', 'docker logs', 5),

-- Module 7 Test Cases
('ptc-7-1', 'proj-7', 'Script exits with code 0', 2, 'EXIT_CODE', '0', 1),
('ptc-7-2', 'proj-7', 'Output contains System Report header', 1, 'STDOUT_CONTAINS', 'System Report', 2),
('ptc-7-3', 'proj-7', 'Output contains Report saved to info', 2, 'STDOUT_CONTAINS', 'Report saved to:', 3),
('ptc-7-4', 'proj-7', 'Script uses df command', 1, 'COMMAND_USED', 'df', 4),
('ptc-7-5', 'proj-7', 'Script uses ps command', 1, 'COMMAND_USED', 'ps', 5),
('ptc-7-6', 'proj-7', 'Script uses ss command', 1, 'COMMAND_USED', 'ss', 6),
('ptc-7-7', 'proj-7', 'Script uses systemctl command', 1, 'COMMAND_USED', 'systemctl', 7),
('ptc-7-8', 'proj-7', 'Script uses tee command', 1, 'COMMAND_USED', 'tee', 8);

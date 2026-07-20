-- Seed data for MCQ assessment questions

-- 1. Assessment Questions
INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-1', 'mod-1', 'Which directory holds system-wide configuration files in a standard Linux system?', '[{"id": "a", "text": "/var"}, {"id": "b", "text": "/etc"}, {"id": "c", "text": "/usr"}, {"id": "d", "text": "/bin"}]', 'b', 'The /etc directory contains system-wide and service-specific configuration files.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-2', 'mod-1', 'What is the primary purpose of the /var directory?', '[{"id": "a", "text": "To store static user binaries"}, {"id": "b", "text": "To hold temporary files deleted on reboot"}, {"id": "c", "text": "To store variable data like logs, databases, and mail spools"}, {"id": "d", "text": "To store system boot files"}]', 'c', '/var contains data that frequently changes during system operation, such as log files and database state.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-3', 'mod-1', 'What is the key difference between / (root) and /root?', '[{"id": "a", "text": "/ is the system root directory; /root is the home directory for the root user"}, {"id": "b", "text": "/ is the root user''s home; /root is the system root directory"}, {"id": "c", "text": "They are identical aliases for the root directory"}, {"id": "d", "text": "/root contains temporary system binaries, while / contains configs"}]', 'a', '/ is the top-level root directory of the filesystem, whereas /root is the dedicated home directory for the root user.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-4', 'mod-1', 'Which command would you use to follow a log file in real-time as new lines are written?', '[{"id": "a", "text": "tail -n 100"}, {"id": "b", "text": "cat -f"}, {"id": "c", "text": "tail -f"}, {"id": "d", "text": "less +G"}]', 'c', 'The -f option of tail tells it to follow the file, printing new lines as they are appended.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-5', 'mod-1', 'What does the ''pwd'' command stand for?', '[{"id": "a", "text": "Print Working Directory"}, {"id": "b", "text": "Path Working Directory"}, {"id": "c", "text": "Process Working Directory"}, {"id": "d", "text": "Personal Workspace Directory"}]', 'a', 'pwd stands for Print Working Directory and prints the absolute path of the current shell session''s location.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-6', 'mod-1', 'Which directory is a virtual filesystem exposing live process and kernel information?', '[{"id": "a", "text": "/sys"}, {"id": "b", "text": "/proc"}, {"id": "c", "text": "/dev"}, {"id": "d", "text": "/run"}]', 'b', 'The /proc directory is a procfs virtual filesystem that provides an interface to kernel data structures and process info.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-7', 'mod-1', 'Which of the following commands is used to view the manual pages for system utilities?', '[{"id": "a", "text": "info"}, {"id": "b", "text": "help"}, {"id": "c", "text": "man"}, {"id": "d", "text": "doc"}]', 'c', 'The man command displays the on-line manual pages for command-line utilities, system calls, and config files.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-8', 'mod-1', 'How does the kernel represent hardware devices like hard drives or USB sticks in the filesystem?', '[{"id": "a", "text": "As binary blocks in /sys/devices"}, {"id": "b", "text": "As text files in /etc/devices"}, {"id": "c", "text": "As device nodes (special files) inside /dev"}, {"id": "d", "text": "As environment variables"}]', 'c', 'Under the ''everything is a file'' model, hardware devices are represented as files in the /dev directory.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-9', 'mod-1', 'What is the command to list all files, including hidden ones, in long-list format?', '[{"id": "a", "text": "ls -la"}, {"id": "b", "text": "ls -h"}, {"id": "c", "text": "ls -all"}, {"id": "d", "text": "ls -R"}]', 'a', 'ls -la lists files in long format (-l) and includes files whose names start with a dot (-a), which are hidden.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-10', 'mod-1', 'Which directory holds temporary files that are usually cleared upon system reboot?', '[{"id": "a", "text": "/var/tmp"}, {"id": "b", "text": "/tmp"}, {"id": "c", "text": "/run/tmp"}, {"id": "d", "text": "/usr/tmp"}]', 'b', 'The /tmp directory is used for short-lived temporary files and is typically cleared on reboot.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-11', 'mod-1', 'What does the command ''cd -'' accomplish?', '[{"id": "a", "text": "Navigates to the user''s home directory"}, {"id": "b", "text": "Navigates to the system root directory"}, {"id": "c", "text": "Navigates back to the previously visited directory"}, {"id": "d", "text": "Closes the current terminal window"}]', 'c', 'cd - toggles the working directory to the value stored in the OLDPWD environment variable (the previous directory).')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-12', 'mod-1', 'Which command shows the location of the binary executable of a command?', '[{"id": "a", "text": "whereis"}, {"id": "b", "text": "which"}, {"id": "c", "text": "locate"}, {"id": "d", "text": "find"}]', 'b', 'which searches the directories listed in the PATH environment variable for the command executable.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-13', 'mod-1', 'Which file type character in an ''ls -l'' permission string represents a directory?', '[{"id": "a", "text": "l"}, {"id": "b", "text": "-"}, {"id": "c", "text": "d"}, {"id": "d", "text": "c"}]', 'c', 'A permission string starting with ''d'' indicates a directory, while ''-'' indicates a regular file.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-14', 'mod-1', 'What is the default behavior of the ''less'' command?', '[{"id": "a", "text": "It displays files page by page, allowing backward and forward navigation"}, {"id": "b", "text": "It prints the entire file to stdout without pagination"}, {"id": "c", "text": "It compresses the target file to save disk space"}, {"id": "d", "text": "It deletes empty lines from the file"}]', 'a', 'less is a terminal pager that reads file contents and allows full backward/forward scrolling without loading the whole file.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-15', 'mod-1', 'Which utility is designed to search for files in a directory hierarchy?', '[{"id": "a", "text": "grep"}, {"id": "b", "text": "find"}, {"id": "c", "text": "locate"}, {"id": "d", "text": "search"}]', 'b', 'The find command searches for files within a directory tree based on criteria such as name, size, type, and age.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-16', 'mod-1', 'Which directory contains essential command-line binaries for all users?', '[{"id": "a", "text": "/sbin"}, {"id": "b", "text": "/usr/local"}, {"id": "c", "text": "/bin"}, {"id": "d", "text": "/lib"}]', 'c', '/bin (often symlinked to /usr/bin in modern systems) contains basic user command binaries.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-17', 'mod-1', 'What is the absolute path representation?', '[{"id": "a", "text": "A path starting from the user''s home directory (~)"}, {"id": "b", "text": "A path starting from the system root directory (/)"}, {"id": "c", "text": "A path that is relative to the current working directory"}, {"id": "d", "text": "A path stored in the PATH environment variable"}]', 'b', 'An absolute path specifies the complete location of a file or directory starting directly from the root (/).')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-18', 'mod-1', 'What is the purpose of the ''head'' command?', '[{"id": "a", "text": "Displays the first few lines of a file (default 10)"}, {"id": "b", "text": "Shows system CPU usage headers"}, {"id": "c", "text": "Prints files to the terminal reversed"}, {"id": "d", "text": "Displays the metadata structure of a disk block"}]', 'a', 'The head command prints the first part (by default, 10 lines) of one or more files to standard output.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-19', 'mod-1', 'Which directory holds libraries required for the binaries in /bin and /sbin?', '[{"id": "a", "text": "/usr/lib"}, {"id": "b", "text": "/lib"}, {"id": "c", "text": "/var/lib"}, {"id": "d", "text": "/etc/lib"}]', 'b', 'The /lib directory (and /lib64) contains shared library images needed to boot the system and run commands.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-1-20', 'mod-1', 'Under the Linux philosophy, what does ''everything is a file'' mean?', '[{"id": "a", "text": "All code is compiled into a single file at boot time"}, {"id": "b", "text": "System resources, devices, and sockets are exposed as file nodes in the filesystem tree"}, {"id": "c", "text": "Linux systems do not use memory buffers, only file reads"}, {"id": "d", "text": "All shell commands must end with .file"}]', 'b', 'The kernel represents hardware devices, sockets, running processes, and settings as files, allowing standard read/write APIs to interact with them.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-1', 'mod-2', 'In the permission string ''-rwxr-xr--'', what is the permission representation for the owner?', '[{"id": "a", "text": "r--"}, {"id": "b", "text": "r-x"}, {"id": "c", "text": "rwx"}, {"id": "d", "text": "-rw"}]', 'c', 'The first triad of permissions after the file type character represents the owner (user). In this case, ''rwx''.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-2', 'mod-2', 'What is the octal representation of the permission string ''-rwxr-xr-x''?', '[{"id": "a", "text": "755"}, {"id": "b", "text": "644"}, {"id": "c", "text": "700"}, {"id": "d", "text": "777"}]', 'a', 'rwx = 4+2+1 = 7; r-x = 4+0+1 = 5; r-x = 4+0+1 = 5. Thus, 755.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-3', 'mod-2', 'Which numeric permission is the standard recommended setting for private SSH keys (e.g. id_rsa)?', '[{"id": "a", "text": "755"}, {"id": "b", "text": "644"}, {"id": "c", "text": "600"}, {"id": "d", "text": "700"}]', 'c', 'Private keys must only be readable and writable by the owner. Permissions of 600 (rw-------) are strictly enforced by SSH.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-4', 'mod-2', 'Which numeric permission is standard for general configuration files, allowing everyone to read but only the owner to write?', '[{"id": "a", "text": "600"}, {"id": "b", "text": "644"}, {"id": "c", "text": "755"}, {"id": "d", "text": "700"}]', 'b', '644 (rw-r--r--) allows the owner to read/write, and group/others to read only. Standard for config files.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-5', 'mod-2', 'Which command is used to change the owner and group of a file named ''app.log''?', '[{"id": "a", "text": "chmod"}, {"id": "b", "text": "chgrp"}, {"id": "c", "text": "chown"}, {"id": "d", "text": "usermod"}]', 'c', 'chown (change owner) is used to modify the owner and/or group of files and directories.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-6', 'mod-2', 'How do you recursively change the owner of ''/app'' and all its contents to ''mandisi:developers''?', '[{"id": "a", "text": "chown -r mandisi:developers /app"}, {"id": "b", "text": "chown -R mandisi:developers /app"}, {"id": "c", "text": "chown -f mandisi:developers /app"}, {"id": "d", "text": "chmod -R mandisi:developers /app"}]', 'b', 'The -R option flags the chown command to run recursively across all subdirectories and files.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-7', 'mod-2', 'Which file holds the local system user database containing user IDs, group IDs, and shell paths?', '[{"id": "a", "text": "/etc/shadow"}, {"id": "b", "text": "/etc/passwd"}, {"id": "c", "text": "/etc/groups"}, {"id": "d", "text": "/var/users"}]', 'b', '/etc/passwd contains user accounts, their UIDs, GIDs, home directory paths, and default login shells.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-8', 'mod-2', 'Which file holds encrypted password hashes for local system accounts?', '[{"id": "a", "text": "/etc/passwd"}, {"id": "b", "text": "/etc/shadow"}, {"id": "c", "text": "/etc/secure"}, {"id": "d", "text": "/var/shadow"}]', 'b', '/etc/shadow stores passwords in encrypted/hashed formats and is restricted from general user access for security.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-9', 'mod-2', 'What is the command to create a new user named ''alice'' with a default home directory?', '[{"id": "a", "text": "useradd alice"}, {"id": "b", "text": "useradd -m alice"}, {"id": "c", "text": "usermod -c alice"}, {"id": "d", "text": "createuser alice"}]', 'b', 'The -m flag creates the user''s home directory (usually /home/alice) when the account is initialized.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-10', 'mod-2', 'Which command appends the group ''sudo'' to the existing groups of user ''alice''?', '[{"id": "a", "text": "usermod -g sudo alice"}, {"id": "b", "text": "usermod -aG sudo alice"}, {"id": "c", "text": "usermod -G sudo alice"}, {"id": "d", "text": "useradd -G sudo alice"}]', 'b', 'usermod -aG appends (-a) the specified groups (-G) to the user''s current group memberships without removing them from others.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-11', 'mod-2', 'What is the secure way to delete a user account named ''alice'' and completely remove their home directory?', '[{"id": "a", "text": "userdel alice"}, {"id": "b", "text": "userdel -r alice"}, {"id": "c", "text": "rm -rf /home/alice"}, {"id": "d", "text": "deluser --delete-home alice"}]', 'b', 'The -r flag with userdel removes the user''s home directory and mail spool along with the user account.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-12', 'mod-2', 'What command prints the numeric User ID (UID) and Group ID (GID) of the current user session?', '[{"id": "a", "text": "whoami"}, {"id": "b", "text": "id"}, {"id": "c", "text": "groups"}, {"id": "d", "text": "uid"}]', 'b', 'The id command prints real and effective user and group IDs.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-13', 'mod-2', 'What does the command ''chmod u+x script.sh'' do?', '[{"id": "a", "text": "Sets execute permission for all users"}, {"id": "b", "text": "Removes write permission from the owner"}, {"id": "c", "text": "Adds execute permission for the owner (user)"}, {"id": "d", "text": "Changes the owner of the script to a user named x"}]', 'c', 'In symbolic mode, ''u'' represents the owner (user), ''+'' adds the permission, and ''x'' represents execute.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-14', 'mod-2', 'In octal permissions, what does value 4 represent?', '[{"id": "a", "text": "Execute only"}, {"id": "b", "text": "Read only"}, {"id": "c", "text": "Write only"}, {"id": "d", "text": "Read and write"}]', 'b', 'The octal permissions are: 4 = read (r), 2 = write (w), 1 = execute (x).')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-15', 'mod-2', 'Which system configuration file contains the database mapping group names to list of members?', '[{"id": "a", "text": "/etc/passwd"}, {"id": "b", "text": "/etc/group"}, {"id": "c", "text": "/etc/shadow"}, {"id": "d", "text": "/etc/gpasswd"}]', 'b', '/etc/group defines the groups on the system and lists users belonging to each group.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-16', 'mod-2', 'What is a security risk of running web applications or containers as the ''root'' user?', '[{"id": "a", "text": "Root processes consume double the CPU resource"}, {"id": "b", "text": "If compromised, the attacker gains full control over the host kernel and filesystem"}, {"id": "c", "text": "Root processes are terminated automatically by OOM killer"}, {"id": "d", "text": "Network ports above 1024 cannot be bound by root"}]', 'b', 'Root processes possess unrestricted capabilities. Compromising a root process bypasses standard filesystem and kernel security boundaries.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-17', 'mod-2', 'Which numeric permission string represents directory access of ''drwx------''?', '[{"id": "a", "text": "600"}, {"id": "b", "text": "755"}, {"id": "c", "text": "700"}, {"id": "d", "text": "777"}]', 'c', 'rwx = 7 for owner, and no permissions (0) for group and others, giving 700.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-18', 'mod-2', 'If a directory has permissions ''755'', what can an ''other'' user (not owner or in group) do?', '[{"id": "a", "text": "Only list the directory and execute/traverse inside it"}, {"id": "b", "text": "Create and delete files inside the directory"}, {"id": "c", "text": "Rename the directory itself"}, {"id": "d", "text": "Change permissions of files inside it"}]', 'a', '755 gives others ''5'' (read and execute). Read allows listing contents; execute allows traversing (cd) into the directory.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-19', 'mod-2', 'What is the purpose of the ''sudo'' command?', '[{"id": "a", "text": "It switches the terminal connection to another remote host"}, {"id": "b", "text": "It executes commands with superuser (root) privileges"}, {"id": "c", "text": "It permanently registers a new daemon"}, {"id": "d", "text": "It compiles source files safely"}]', 'b', 'sudo (superuser do) lets permitted users run commands as the root user or another system user.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-2-20', 'mod-2', 'Which command can show the list of groups that the current user belongs to?', '[{"id": "a", "text": "whoami"}, {"id": "b", "text": "groups"}, {"id": "c", "text": "id -g"}, {"id": "d", "text": "cat /etc/groups"}]', 'b', 'The groups command prints the names of primary and supplementary groups of the current session user.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-1', 'mod-3', 'What column in ''ps aux'' represents the physical memory (RAM) actually used by a process?', '[{"id": "a", "text": "VSZ"}, {"id": "b", "text": "RSS"}, {"id": "c", "text": "%MEM"}, {"id": "d", "text": "SIZE"}]', 'b', 'RSS (Resident Set Size) is the non-swapped physical memory that a process has used, measured in kilobytes.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-2', 'mod-3', 'Which signal number corresponds to SIGKILL, which forces immediate process termination?', '[{"id": "a", "text": "15"}, {"id": "b", "text": "9"}, {"id": "c", "text": "1"}, {"id": "d", "text": "2"}]', 'b', 'SIGKILL is signal 9. It cannot be caught, blocked, or ignored, and instantly kills the process.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-3', 'mod-3', 'Which signal is sent when you press ''Ctrl+C'' in a terminal session?', '[{"id": "a", "text": "SIGTERM"}, {"id": "b", "text": "SIGKILL"}, {"id": "c", "text": "SIGINT"}, {"id": "d", "text": "SIGTSTP"}]', 'c', 'Ctrl+C sends the SIGINT (interrupt) signal, which defaults to terminating the foreground process cleanly.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-4', 'mod-3', 'Why is it best practice to send SIGTERM (15) before SIGKILL (9)?', '[{"id": "a", "text": "SIGKILL uses double the CPU overhead"}, {"id": "b", "text": "SIGTERM allows the process to flush buffers, close connections, and clean up resources"}, {"id": "c", "text": "SIGKILL is restricted to users inside the sudoers list"}, {"id": "d", "text": "SIGTERM is processed faster by the scheduler"}]', 'b', 'SIGTERM requests polite termination, allowing the program a chance to save state and shut down gracefully.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-5', 'mod-3', 'Which character is appended to a command line to start it as a background job?', '[{"id": "a", "text": "@"}, {"id": "b", "text": "%"}, {"id": "c", "text": "&"}, {"id": "d", "text": "*"}]', 'c', 'Appending ''&'' to a command tells the shell to run the command in the background, freeing up the prompt.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-6', 'mod-3', 'Which command is used to resume a paused job and keep it running in the background?', '[{"id": "a", "text": "fg"}, {"id": "b", "text": "bg"}, {"id": "c", "text": "jobs"}, {"id": "d", "text": "resume"}]', 'b', 'The bg command (e.g. bg %1) resumes a stopped job in the background.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-7', 'mod-3', 'What is a zombie process in Linux?', '[{"id": "a", "text": "A process that consumes 100% CPU in an infinite loop"}, {"id": "b", "text": "A process that has finished execution but still has an entry in the process table"}, {"id": "c", "text": "A system service launched without a config file"}, {"id": "d", "text": "A network listener running on port 0"}]', 'b', 'A zombie process has exited, but its parent process has not yet read its exit status via wait(), so it remains in the process table.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-8', 'mod-3', 'Which file displays the system''s CPU load averages for the last 1, 5, and 15 minutes?', '[{"id": "a", "text": "/proc/meminfo"}, {"id": "b", "text": "/proc/loadavg"}, {"id": "c", "text": "/proc/cpuinfo"}, {"id": "d", "text": "/proc/uptime"}]', 'b', '/proc/loadavg displays system load averages, runnable processes count, and the last allocated PID.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-9', 'mod-3', 'How do you view detailed real-time memory usage in human-readable terms?', '[{"id": "a", "text": "df -h"}, {"id": "b", "text": "free -h"}, {"id": "c", "text": "uptime"}, {"id": "d", "text": "du -sh"}]', 'b', 'free -h displays total, used, free, shared, buff/cache, and available system memory in friendly formats (GB, MB).')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-10', 'mod-3', 'What is the command to list background jobs in the current shell session?', '[{"id": "a", "text": "ps aux"}, {"id": "b", "text": "jobs"}, {"id": "c", "text": "bg"}, {"id": "d", "text": "pkill"}]', 'b', 'The jobs command lists active, stopped, or background jobs spawned from the current active shell.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-11', 'mod-3', 'What command is used to bring a background job back into the foreground?', '[{"id": "a", "text": "bg"}, {"id": "b", "text": "fg"}, {"id": "c", "text": "jobs -f"}, {"id": "d", "text": "kill"}]', 'b', 'fg (e.g. fg %1) moves a background or suspended job to the foreground shell process.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-12', 'mod-3', 'Which command kills all processes that match a specific name pattern?', '[{"id": "a", "text": "pkill"}, {"id": "b", "text": "killall"}, {"id": "c", "text": "kill -p"}, {"id": "d", "text": "SIGKILL"}]', 'a', 'pkill kills processes based on name patterns or attributes, while killall matches exact names.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-13', 'mod-3', 'What does the command ''nohup ./script.sh &'' do?', '[{"id": "a", "text": "Runs the script without root privileges"}, {"id": "b", "text": "Runs the script in the background and prevents it from being terminated if the user logs out"}, {"id": "c", "text": "Compiles the script silently"}, {"id": "d", "text": "Runs the script with high priority scheduling"}]', 'b', 'nohup redirects SIGHUP, allowing background commands to survive shell session disconnects.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-14', 'mod-3', 'What is the purpose of the $$ shell variable?', '[{"id": "a", "text": "Displays the exit code of the last run command"}, {"id": "b", "text": "Holds the Process ID (PID) of the current shell process"}, {"id": "c", "text": "Calculates memory load"}, {"id": "d", "text": "Represents the root user status"}]', 'b', '$$ evaluates to the PID of the active shell executing the command.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-15', 'mod-3', 'Which directory exposes the file descriptors currently held open by a process with PID 1234?', '[{"id": "a", "text": "/proc/1234/fd/"}, {"id": "b", "text": "/proc/1234/status/"}, {"id": "c", "text": "/var/run/1234/"}, {"id": "d", "text": "/dev/fd/1234/"}]', 'a', 'Each file descriptor opened by a process is represented as a symbolic link in the process''s /proc/[PID]/fd/ subdirectory.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-16', 'mod-3', 'What is the difference between VSZ (Virtual Size) and RSS (Resident Set Size) in ''ps aux''?', '[{"id": "a", "text": "RSS is memory allocated on disk, VSZ is physical RAM"}, {"id": "b", "text": "VSZ represents total virtual memory allocated, including shared libraries and swapped pages; RSS represents physical RAM in active use"}, {"id": "c", "text": "They are exactly the same"}, {"id": "d", "text": "VSZ is only for kernel threads, RSS is for user space"}]', 'b', 'VSZ accounts for all memory the process can access, while RSS reflects actual physical memory page allocations.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-17', 'mod-3', 'What command is used to display CPU architecture and number of logical CPU cores?', '[{"id": "a", "text": "nproc"}, {"id": "b", "text": "free"}, {"id": "c", "text": "uptime"}, {"id": "d", "text": "df"}]', 'a', 'nproc prints the number of processing units (logical CPU cores) available to the system.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-18', 'mod-3', 'Which signal is sent when SIGHUP (1) is received by daemons like Nginx or SSH?', '[{"id": "a", "text": "Force termination"}, {"id": "b", "text": "Configuration reload without restarting"}, {"id": "c", "text": "Write core dump to disk"}, {"id": "d", "text": "Pause execution"}]', 'b', 'By convention, receiving SIGHUP instructs background daemons to reload their configurations and re-open logs without terminating active connections.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-19', 'mod-3', 'Which key combination sends SIGTSTP to pause the active foreground process?', '[{"id": "a", "text": "Ctrl+C"}, {"id": "b", "text": "Ctrl+Z"}, {"id": "c", "text": "Ctrl+\\\\"}, {"id": "d", "text": "Ctrl+D"}]', 'b', 'Ctrl+Z sends SIGTSTP (terminal stop), which suspends the foreground process and moves control back to shell.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-3-20', 'mod-3', 'Which directory holds global kernel runtime configurations that can be modified dynamically?', '[{"id": "a", "text": "/proc/sys/"}, {"id": "b", "text": "/etc/sysconfig/"}, {"id": "c", "text": "/sys/kernel/"}, {"id": "d", "text": "/var/run/"}]', 'a', 'The /proc/sys/ directory contains files representing kernel parameters that can be queried or modified at runtime.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-1', 'mod-4', 'Which utility is used to query active network connections and listening sockets on modern Linux distributions?', '[{"id": "a", "text": "netstat"}, {"id": "b", "text": "ss"}, {"id": "c", "text": "ifconfig"}, {"id": "d", "text": "ping"}]', 'b', 'ss is the modern utility replacing netstat for dump-format socket statistics.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-2', 'mod-4', 'What is the standard port for the SSH service?', '[{"id": "a", "text": "80"}, {"id": "b", "text": "443"}, {"id": "c", "text": "22"}, {"id": "d", "text": "8080"}]', 'c', 'SSH (Secure Shell) runs on TCP port 22 by default.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-3', 'mod-4', 'What does the IP address ''127.0.0.1'' represent?', '[{"id": "a", "text": "The local router''s gateway"}, {"id": "b", "text": "The default DNS server"}, {"id": "c", "text": "The loopback interface (localhost)"}, {"id": "d", "text": "The external public IP"}]', 'c', '127.0.0.1 is the loopback IPv4 address, referencing the local computer itself.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-4', 'mod-4', 'What does listening on ''0.0.0.0'' mean for a network service?', '[{"id": "a", "text": "It only accepts connections from localhost"}, {"id": "b", "text": "It is closed and not listening to anything"}, {"id": "c", "text": "It binds to all network interfaces, making it reachable from outside hosts"}, {"id": "d", "text": "It uses random local ports"}]', 'c', '0.0.0.0 indicates a service listens on all network interfaces of the host.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-5', 'mod-4', 'Which command shows which process is listening on port 8080?', '[{"id": "a", "text": "lsof -i :8080"}, {"id": "b", "text": "ping localhost:8080"}, {"id": "c", "text": "dig :8080"}, {"id": "d", "text": "ss -t :8080"}]', 'a', 'lsof -i :8080 lists open internet socket files corresponding to port 8080 along with process PIDs.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-6', 'mod-4', 'What file configures the system''s DNS nameservers?', '[{"id": "a", "text": "/etc/hosts"}, {"id": "b", "text": "/etc/resolv.conf"}, {"id": "c", "text": "/etc/hostname"}, {"id": "d", "text": "/var/run/dns"}]', 'b', '/etc/resolv.conf is the resolver configuration file containing nameserver IPs.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-7', 'mod-4', 'Which file is checked first for local hostname resolution overrides before querying external DNS?', '[{"id": "a", "text": "/etc/resolv.conf"}, {"id": "b", "text": "/etc/hosts"}, {"id": "c", "text": "/etc/hostname"}, {"id": "d", "text": "/etc/networks"}]', 'b', '/etc/hosts contains static mappings of IP addresses to hostnames and is queried first.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-8', 'mod-4', 'What netcat command flags are used to perform a quick port scan to check if port 5432 is open?', '[{"id": "a", "text": "nc -zv localhost 5432"}, {"id": "b", "text": "nc -l localhost 5432"}, {"id": "c", "text": "nc -p localhost 5432"}, {"id": "d", "text": "nc -u localhost 5432"}]', 'a', '-z is zero-I/O mode (used for scanning), and -v increases verbosity to output success/failure.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-9', 'mod-4', 'Which command resolves the hostname ''google.com'' to its IP addresses using command line utilities?', '[{"id": "a", "text": "ping google.com"}, {"id": "b", "text": "dig google.com"}, {"id": "c", "text": "curl google.com"}, {"id": "d", "text": "tracepath google.com"}]', 'b', 'dig (domain information groper) is a flexible command-line tool for querying DNS name servers.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-10', 'mod-4', 'What does the Wi-Fi interface named ''wlp0s20f3'' signify in modern Linux persistent naming conventions?', '[{"id": "a", "text": "A wired ethernet port"}, {"id": "b", "text": "A wireless PCI interface"}, {"id": "c", "text": "A Docker virtual bridge"}, {"id": "d", "text": "A local loopback device"}]', 'b', 'Names starting with ''wl'' signify wireless, ''p0s20f3'' represents the physical bus location (PCI bus 0, slot 20, function 3).')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-11', 'mod-4', 'Which option in curl is used to view request and response headers along with handshake details?', '[{"id": "a", "text": "-I"}, {"id": "b", "text": "-v"}, {"id": "c", "text": "-s"}, {"id": "d", "text": "-o"}]', 'b', '-v (verbose) makes curl show all headers, handshakes, IP selection, and transport information.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-12', 'mod-4', 'Which command is used to securely copy public SSH keys to a remote server''s authorized_keys?', '[{"id": "a", "text": "ssh-keygen"}, {"id": "b", "text": "ssh-copy-id"}, {"id": "c", "text": "scp"}, {"id": "d", "text": "ssh-add"}]', 'b', 'ssh-copy-id connects to the remote host, uploads the key, and appends it to authorized_keys with correct permissions.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-13', 'mod-4', 'What port is default for PostgreSQL databases?', '[{"id": "a", "text": "3306"}, {"id": "b", "text": "5432"}, {"id": "c", "text": "6379"}, {"id": "d", "text": "8080"}]', 'b', 'PostgreSQL listens on port 5432 by default.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-14', 'mod-4', 'What port is default for MySQL databases?', '[{"id": "a", "text": "5432"}, {"id": "b", "text": "3306"}, {"id": "c", "text": "6379"}, {"id": "d", "text": "8080"}]', 'b', 'MySQL listens on port 3306 by default.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-15', 'mod-4', 'What port is default for Redis?', '[{"id": "a", "text": "3306"}, {"id": "b", "text": "6379"}, {"id": "c", "text": "22"}, {"id": "d", "text": "80"}]', 'b', 'Redis defaults to port 6379.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-16', 'mod-4', 'In SSH config (~/.ssh/config), what directive configures the username used for SSH authentication?', '[{"id": "a", "text": "UserName"}, {"id": "b", "text": "User"}, {"id": "c", "text": "Login"}, {"id": "d", "text": "Identity"}]', 'b', 'The User directive defines the remote username to authenticate as (e.g. User mandisi).')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-17', 'mod-4', 'What does the option ''ss -tulnp'' stand for?', '[{"id": "a", "text": "TCP, UDP, Listening, Numeric, Process Info"}, {"id": "b", "text": "Tunnel, User, Log, Network, Packet"}, {"id": "c", "text": "Terminal, Unique, Local, Net, Ping"}, {"id": "d", "text": "Thread, Unicast, Loopback, Node, Port"}]', 'a', 't = TCP, u = UDP, l = listening sockets, n = numeric values (ports/addresses as numbers), p = process ID and name.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-18', 'mod-4', 'What is the standard port for secure HTTPS web traffic?', '[{"id": "a", "text": "80"}, {"id": "b", "text": "443"}, {"id": "c", "text": "8080"}, {"id": "d", "text": "8443"}]', 'b', 'HTTPS is standardized to run on port 443.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-19', 'mod-4', 'Which interface name represents the default local bridge network created by Docker?', '[{"id": "a", "text": "lo"}, {"id": "b", "text": "docker0"}, {"id": "c", "text": "eth0"}, {"id": "d", "text": "wlp0s20"}]', 'b', 'Docker uses docker0 to route container-host traffic.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-4-20', 'mod-4', 'How does the ping utility check basic network connectivity?', '[{"id": "a", "text": "By opening a TCP connection to port 80"}, {"id": "b", "text": "By sending ICMP Echo Request packets and listening for Echo Replies"}, {"id": "c", "text": "By querying DNS records"}, {"id": "d", "text": "By sending raw UDP datagrams to port 7"}]', 'b', 'ping uses ICMP (Internet Control Message Protocol) to test if an IP address is reachable.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-1', 'mod-5', 'Which directory holds custom administrator-created systemd service files?', '[{"id": "a", "text": "/lib/systemd/system/"}, {"id": "b", "text": "/etc/systemd/system/"}, {"id": "c", "text": "/var/systemd/system/"}, {"id": "d", "text": "/usr/lib/systemd/"}]', 'b', 'Custom systemd unit definitions go in /etc/systemd/system/ and override the default files in /lib/systemd/system/.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-2', 'mod-5', 'What is the command to make a systemd service start automatically at boot time?', '[{"id": "a", "text": "systemctl start service_name"}, {"id": "b", "text": "systemctl enable service_name"}, {"id": "c", "text": "systemctl auto service_name"}, {"id": "d", "text": "systemctl register service_name"}]', 'b', 'systemctl enable creates symlinks in systemd targets so the service runs automatically when targets activate at boot.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-3', 'mod-5', 'Which utility is used to query and view system logs written by systemd-journald?', '[{"id": "a", "text": "logctl"}, {"id": "b", "text": "journalctl"}, {"id": "c", "text": "syslog"}, {"id": "d", "text": "tail /var/log/syslog"}]', 'b', 'journalctl is the official systemd client utility to search and print journal logs.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-4', 'mod-5', 'How do you follow logs for a service named ''nginx'' in real-time?', '[{"id": "a", "text": "journalctl -u nginx -f"}, {"id": "b", "text": "journalctl -u nginx -n 100"}, {"id": "c", "text": "systemctl tail nginx"}, {"id": "d", "text": "tail -f /var/log/nginx"}]', 'a', '-u filters logs by unit, and -f follows the log output in real-time.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-5', 'mod-5', 'What systemctl command shows the current status, PID, and latest logs of a service?', '[{"id": "a", "text": "systemctl start service_name"}, {"id": "b", "text": "systemctl status service_name"}, {"id": "c", "text": "systemctl check service_name"}, {"id": "d", "text": "systemctl show service_name"}]', 'b', 'systemctl status shows operational status, loaded file, active state, main PID, memory footprint, and recent journal entries.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-6', 'mod-5', 'Which systemd target represents standard multi-user console mode (non-graphical boot)?', '[{"id": "a", "text": "graphical.target"}, {"id": "b", "text": "multi-user.target"}, {"id": "c", "text": "rescue.target"}, {"id": "d", "text": "reboot.target"}]', 'b', 'multi-user.target is the standard headless console target, equivalent to SysV runlevel 3.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-7', 'mod-5', 'How do you reload systemd''s manager configuration, picking up newly created or edited unit files?', '[{"id": "a", "text": "systemctl restart systemd"}, {"id": "b", "text": "systemctl daemon-reload"}, {"id": "c", "text": "systemctl reload-daemon"}, {"id": "d", "text": "systemctl update"}]', 'b', 'daemon-reload forces systemd to reload all unit files and rebuild dependencies.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-8', 'mod-5', 'What directive in a systemd service file specifies the user account that the service process runs under?', '[{"id": "a", "text": "RunAsUser="}, {"id": "b", "text": "User="}, {"id": "c", "text": "UID="}, {"id": "d", "text": "Username="}]', 'b', 'The User= directive inside the [Service] block defines the Unix user account to execute the process.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-9', 'mod-5', 'What is the function of ''systemctl stop service_name''?', '[{"id": "a", "text": "It permanently disables the service from starting"}, {"id": "b", "text": "It terminates the running process immediately (sending SIGKILL)"}, {"id": "c", "text": "It requests the service to stop by sending SIGTERM to the process group"}, {"id": "d", "text": "It pauses the service process in memory"}]', 'c', 'systemctl stop sends a SIGTERM (by default) to the service, asking it to clean up and exit.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-10', 'mod-5', 'How do you view only kernel logs using journalctl?', '[{"id": "a", "text": "journalctl -u kernel"}, {"id": "b", "text": "journalctl -k"}, {"id": "c", "text": "journalctl --kernel"}, {"id": "d", "text": "cat /var/log/kern.log"}]', 'b', 'The -k (or --dmesg) option limits output to kernel journal messages.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-11', 'mod-5', 'Which directive in systemd specifies what command to run when the service starts?', '[{"id": "a", "text": "ExecStart="}, {"id": "b", "text": "Command="}, {"id": "c", "text": "Start="}, {"id": "d", "text": "Exec="}]', 'a', 'ExecStart= inside the [Service] block defines the command line to execute when initiating the service.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-12', 'mod-5', 'What command is used to disable a service, stopping it from starting automatically at boot?', '[{"id": "a", "text": "systemctl stop"}, {"id": "b", "text": "systemctl disable"}, {"id": "c", "text": "systemctl deactivate"}, {"id": "d", "text": "systemctl remove"}]', 'b', 'disable removes symlinks from targets, preventing the service from launching during boot.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-13', 'mod-5', 'In journalctl, what flag is used to show logs starting from a specific date/time?', '[{"id": "a", "text": "-t"}, {"id": "b", "text": "--since"}, {"id": "c", "text": "--after"}, {"id": "d", "text": "-f"}]', 'b', '--since (e.g. --since ''1 hour ago'' or --since ''2026-06-17'') filters logs to show only entries after that point.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-14', 'mod-5', 'What is PID 1 in a modern Linux system?', '[{"id": "a", "text": "The bash shell"}, {"id": "b", "text": "systemd"}, {"id": "c", "text": "The kernel scheduler"}, {"id": "d", "text": "kthreadd"}]', 'b', 'systemd is the init process (PID 1) that spawns all other userspace processes.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-15', 'mod-5', 'Which directive inside [Install] section of a systemd unit maps it to multi-user boot targets?', '[{"id": "a", "text": "RequiredBy=multi-user.target"}, {"id": "b", "text": "WantedBy=multi-user.target"}, {"id": "c", "text": "WantedBy=default.target"}, {"id": "d", "text": "TriggeredBy=multi-user.target"}]', 'b', 'WantedBy=multi-user.target creates a weak dependency link so the service launches when entering multi-user mode.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-16', 'mod-5', 'What is the difference between restart and reload in systemctl?', '[{"id": "a", "text": "Restart stops and starts the process; reload asks the process to update config without stopping"}, {"id": "b", "text": "Reload is faster and always restarts the process"}, {"id": "c", "text": "Restart is only for system services; reload is for kernel drivers"}, {"id": "d", "text": "They are exactly identical"}]', 'a', 'Restart stops the daemon process and starts a new one; reload sends SIGHUP or similar to reload configurations in-place.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-17', 'mod-5', 'What command shows logs only for the current boot session?', '[{"id": "a", "text": "journalctl -k"}, {"id": "b", "text": "journalctl -b"}, {"id": "c", "text": "journalctl -f"}, {"id": "d", "text": "journalctl -u boot"}]', 'b', '-b (or --boot) limits logs to entries from the current boot session.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-18', 'mod-5', 'What directive in a systemd service file defines the working directory for the process?', '[{"id": "a", "text": "Cwd="}, {"id": "b", "text": "WorkingDirectory="}, {"id": "c", "text": "Directory="}, {"id": "d", "text": "Folder="}]', 'b', 'WorkingDirectory= sets the current working directory for the spawned command execution.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-19', 'mod-5', 'What directive in systemd defines restart behavior if the process exits unexpectedly?', '[{"id": "a", "text": "AutoRestart="}, {"id": "b", "text": "Restart="}, {"id": "c", "text": "KeepAlive="}, {"id": "d", "text": "OnFailure="}]', 'b', 'Restart= (e.g. Restart=on-failure or Restart=always) tells systemd to automatically re-launch the service on unexpected exits.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-5-20', 'mod-5', 'What does the command ''systemctl is-active service_name'' do?', '[{"id": "a", "text": "Prints a verbose report of the service"}, {"id": "b", "text": "Outputs ''active'' or ''inactive'' and exits with a status code representing state"}, {"id": "c", "text": "Kills the service if inactive"}, {"id": "d", "text": "Sets the service state to active"}]', 'b', 'is-active queries the state, returning a success exit code (0) if the service is running.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-1', 'mod-6', 'Which Linux kernel feature isolates system resources (PID, Network, Mount) for a container?', '[{"id": "a", "text": "cgroups"}, {"id": "b", "text": "Namespaces"}, {"id": "c", "text": "chroot"}, {"id": "d", "text": "SELinux"}]', 'b', 'Namespaces provide isolation of global system resources, making a process believe it has its own dedicated system instance.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-2', 'mod-6', 'Which Linux kernel feature limits and monitors resource usage (CPU, Memory, Disk I/O) for containers?', '[{"id": "a", "text": "Namespaces"}, {"id": "b", "text": "cgroups (control groups)"}, {"id": "c", "text": "OverlayFS"}, {"id": "d", "text": "AppArmor"}]', 'b', 'cgroups (control groups) constrain the amount of physical resources (memory, CPU, I/O) a process or group of processes can consume.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-3', 'mod-6', 'What namespace isolates the network stack (interfaces, routing tables, port bindings)?', '[{"id": "a", "text": "PID namespace"}, {"id": "b", "text": "Net (network) namespace"}, {"id": "c", "text": "Mnt namespace"}, {"id": "d", "text": "IPC namespace"}]', 'b', 'The net namespace isolates network devices, IP routing tables, port numbers, and firewall rules.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-4', 'mod-6', 'What namespace isolates the process ID space, allowing a container process to have PID 1?', '[{"id": "a", "text": "UTS namespace"}, {"id": "b", "text": "PID namespace"}, {"id": "c", "text": "User namespace"}, {"id": "d", "text": "IPC namespace"}]', 'b', 'The PID namespace isolates the process ID space, letting a container process be PID 1 while mapping to a normal PID on the host.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-5', 'mod-6', 'What filesystem mechanism layers a read-write top layer over read-only image layers to form a container''s filesystem?', '[{"id": "a", "text": "ext4"}, {"id": "b", "text": "OverlayFS"}, {"id": "c", "text": "NFS"}, {"id": "d", "text": "tmpfs"}]', 'b', 'OverlayFS merges multiple directory branches into a single mount, implementing the copy-on-write image layers of containers.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-6', 'mod-6', 'What syscall does a container runtime use to change the root directory of a process to the container image root?', '[{"id": "a", "text": "pivot_root"}, {"id": "b", "text": "chroot"}, {"id": "c", "text": "Both pivot_root and chroot"}, {"id": "d", "text": "sys_exec"}]', 'c', 'chroot changes the root directory path. In container engines, pivot_root is preferred because it moves the entire mount namespace root and unmounts the old host root safely.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-7', 'mod-6', 'What is the purpose of cgroups memory limits?', '[{"id": "a", "text": "It isolates network traffic rate limits"}, {"id": "b", "text": "It prevents a container process from using more memory than allowed, trigger OOM kill if exceeded"}, {"id": "c", "text": "It increases disk write speed"}, {"id": "d", "text": "It allocates virtual disk partitions"}]', 'b', 'cgroups memory subsystem tracks physical RAM allocations and triggers the Out-Of-Memory (OOM) killer to terminate processes that breach the configured boundary.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-8', 'mod-6', 'What is the namespace that isolates hostname and NIS domain names?', '[{"id": "a", "text": "UTS namespace"}, {"id": "b", "text": "User namespace"}, {"id": "c", "text": "Mnt namespace"}, {"id": "d", "text": "IPC namespace"}]', 'a', 'UTS (UNIX Timesharing System) namespace permits a container to define its own hostname and domain name.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-9', 'mod-6', 'How does the ''copy-on-write'' (CoW) design work in containers?', '[{"id": "a", "text": "Every file is copied to a USB drive automatically"}, {"id": "b", "text": "Files in lower read-only layers are copied to the upper read-write layer only when modified"}, {"id": "c", "text": "Files are deleted after they are read"}, {"id": "d", "text": "It forces files to lock when double writers occur"}]', 'b', 'Under CoW, read-only layers are shared. If a container modifies a file, OverlayFS copies it to the upper writable layer before writing changes.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-10', 'mod-6', 'What system command checks namespaces of running processes?', '[{"id": "a", "text": "nsenter"}, {"id": "b", "text": "lsns"}, {"id": "c", "text": "ip netns"}, {"id": "d", "text": "ps -ns"}]', 'b', 'lsns lists all active namespaces in the kernel along with their types and controlling PIDs.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-11', 'mod-6', 'Which command executes a program inside the namespaces of another running process?', '[{"id": "a", "text": "lsns"}, {"id": "b", "text": "nsenter"}, {"id": "c", "text": "chroot"}, {"id": "d", "text": "docker run"}]', 'b', 'nsenter runs commands in the context of specified namespaces (e.g. entering a container''s network namespace for debugging).')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-12', 'mod-6', 'What is the purpose of the User namespace?', '[{"id": "a", "text": "To log users out of terminals"}, {"id": "b", "text": "To map container UIDs/GIDs to different UIDs/GIDs on the host system"}, {"id": "c", "text": "To create new system group databases"}, {"id": "d", "text": "To limit maximum user file sizes"}]', 'b', 'User namespaces enable a process to have root privileges (UID 0) inside the container while mapping to an unprivileged user ID on the host.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-13', 'mod-6', 'Which Docker storage driver is the standard on modern Linux systems?', '[{"id": "a", "text": "aufs"}, {"id": "b", "text": "overlay2"}, {"id": "c", "text": "devicemapper"}, {"id": "d", "text": "vfs"}]', 'b', 'overlay2 is the recommended storage driver for modern Docker engines due to high-performance page cache utilization.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-14', 'mod-6', 'Which directory in modern systems holds the control group hierarchy parameters?', '[{"id": "a", "text": "/proc/cgroups/"}, {"id": "b", "text": "/sys/fs/cgroup/"}, {"id": "c", "text": "/etc/cgroups/"}, {"id": "d", "text": "/var/run/cgroups/"}]', 'b', '/sys/fs/cgroup/ contains virtual file entries representing the active cgroups system hierarchy.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-15', 'mod-6', 'In Kubernetes, what container runtime interface is systemd integrated with to limit pod resources?', '[{"id": "a", "text": "systemd cgroup driver"}, {"id": "b", "text": "cgroupfs driver"}, {"id": "c", "text": "cgroups v3"}, {"id": "d", "text": "kube-cgroup"}]', 'a', 'Kubernetes recommends using the systemd cgroup driver when systemd is init, ensuring single-ownership of resource hierarchies.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-16', 'mod-6', 'What namespace isolates IPC (Inter-Process Communication) mechanisms like message queues?', '[{"id": "a", "text": "UTS namespace"}, {"id": "b", "text": "IPC namespace"}, {"id": "c", "text": "Mnt namespace"}, {"id": "d", "text": "User namespace"}]', 'b', 'The IPC namespace isolates System V IPC objects and POSIX message queues.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-17', 'mod-6', 'What namespace isolates filesystem mount points, keeping container mounts separate from host mounts?', '[{"id": "a", "text": "UTS namespace"}, {"id": "b", "text": "Mnt (mount) namespace"}, {"id": "c", "text": "User namespace"}, {"id": "d", "text": "PID namespace"}]', 'b', 'The mnt namespace isolates mount tables, so mount/unmount operations inside do not affect other processes.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-18', 'mod-6', 'What command maps to resources.limits.cpu in Kubernetes at the cgroups level?', '[{"id": "a", "text": "cpu.shares / cpu.cfs_quota_us"}, {"id": "b", "text": "cpu.max / cpu.weight"}, {"id": "c", "text": "Both cpu.shares and cpu.cfs_quota_us depending on v1 or v2"}, {"id": "d", "text": "cpu.limits"}]', 'c', 'CPU limits translate to cpu.cfs_quota_us (CFS bandwidth control) or cpu.max in cgroups v2.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-19', 'mod-6', 'What is the difference between cgroups v1 and cgroups v2?', '[{"id": "a", "text": "cgroups v1 is written in C, v2 is in Go"}, {"id": "b", "text": "cgroups v2 uses a single unified hierarchy, whereas v1 used separate hierarchies for each resource controller"}, {"id": "c", "text": "cgroups v2 has no support for memory limits"}, {"id": "d", "text": "They are exactly the same"}]', 'b', 'cgroups v2 simplifies resource management by putting all controllers (CPU, memory, I/O) on a single unified process tree hierarchy.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-6-20', 'mod-6', 'What command shows details of the container engine runtime?', '[{"id": "a", "text": "docker info"}, {"id": "b", "text": "crictl info"}, {"id": "c", "text": "Both docker info and crictl info depending on runtime"}, {"id": "d", "text": "systemctl status docker"}]', 'c', 'docker info provides details for Docker engine, while crictl info displays containerd runtime stats.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-1', 'mod-7', 'What is the difference between double quotes ("") and single quotes ('''') in bash?', '[{"id": "a", "text": "Single quotes allow variable expansion, double quotes do not"}, {"id": "b", "text": "Double quotes expand variables and command substitutions, single quotes treat all characters literally"}, {"id": "c", "text": "Double quotes are faster than single quotes"}, {"id": "d", "text": "Single quotes compile commands"}]', 'b', 'Double quotes evaluate ''$var'' and ''$(cmd)''. Single quotes prevent all forms of shell expansion.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-2', 'mod-7', 'Why should variables containing filenames or paths almost always be enclosed in double quotes (e.g. "$FILE")?', '[{"id": "a", "text": "To compile the file faster"}, {"id": "b", "text": "To prevent word splitting and globbing if the file path contains whitespace"}, {"id": "c", "text": "To make the variable read-only"}, {"id": "d", "text": "To make the variable global"}]', 'b', 'Without double quotes, paths containing spaces will be split into multiple arguments by the shell parser.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-3', 'mod-7', 'In bash, what is the exit status code representing success?', '[{"id": "a", "text": "1"}, {"id": "b", "text": "0"}, {"id": "c", "text": "-1"}, {"id": "d", "text": "200"}]', 'b', 'An exit status of 0 means the command completed successfully. Non-zero values represent errors.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-4', 'mod-7', 'What does the command ''set -e'' at the top of a shell script do?', '[{"id": "a", "text": "It prints every command to screen before executing"}, {"id": "b", "text": "It causes the script to exit immediately if any command returns a non-zero exit status"}, {"id": "c", "text": "It sets all variables as exported"}, {"id": "d", "text": "It suppresses all stderr output"}]', 'b', 'set -e (exit on error) stops script execution when a pipeline or command fails, preventing cascading errors.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-5', 'mod-7', 'What is the difference between ''[ ]'' and ''[[ ]]'' in bash scripting?', '[{"id": "a", "text": "''[[ ]]'' is a modern bash keyword that is safer, supporting advanced features like regular expressions and logical operators directly without quoting issues"}, {"id": "b", "text": "''[ ]'' is faster because it compiles to binary"}, {"id": "c", "text": "They are exactly identical"}, {"id": "d", "text": "''[[ ]]'' can only be used by root"}]', 'a', '[[ ]] is a built-in bash keyword that avoids word splitting, offers regex matching (=~), and handles logical operations (&&, ||) natively.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-6', 'mod-7', 'Which of the following represents the correct Cron schedule format?', '[{"id": "a", "text": "Hour Minute Day Month Week Command"}, {"id": "b", "text": "Minute Hour Day Month Day_of_Week Command"}, {"id": "c", "text": "Command Minute Hour Day Month"}, {"id": "d", "text": "Second Minute Hour Day Month Command"}]', 'b', 'The standard cron format is: Minute Hour Day_of_Month Month Day_of_Week Command.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-7', 'mod-7', 'What does Cron schedule ''0 5 * * 1'' execute?', '[{"id": "a", "text": "Every 5 minutes on Monday"}, {"id": "b", "text": "At 5:00 AM every Monday"}, {"id": "c", "text": "At 5:00 AM on the 1st of every month"}, {"id": "d", "text": "Every 5 hours"}]', 'b', '0 = minute 0, 5 = hour 5 (5 AM), * = daily, * = monthly, 1 = Monday (0/7 is Sun, 1 is Mon).')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-8', 'mod-7', 'How do you capture the standard output of a command into a variable in bash?', '[{"id": "a", "text": "VAR=cmd"}, {"id": "b", "text": "VAR=$(cmd)"}, {"id": "c", "text": "VAR=read(cmd)"}, {"id": "d", "text": "VAR={cmd}"}]', 'b', 'The $(command) construct executes the command and substitutes its standard output, assigning it to VAR.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-9', 'mod-7', 'What shell option prints commands and their arguments as they are executed (useful for debugging)?', '[{"id": "a", "text": "set -e"}, {"id": "b", "text": "set -x"}, {"id": "c", "text": "set -u"}, {"id": "d", "text": "set -o pipefail"}]', 'b', 'set -x (or running bash -x) prints trace logs for executed commands, expanding variables.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-10', 'mod-7', 'How do you retrieve the exit code of the last executed command?', '[{"id": "a", "text": "$?"}, {"id": "b", "text": "$!"}, {"id": "c", "text": "$#"}, {"id": "d", "text": "$@"}]', 'a', '$? contains the exit status code of the most recently executed foreground pipeline.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-11', 'mod-7', 'What does the shell variable ''$#'' represent?', '[{"id": "a", "text": "The Process ID of the script"}, {"id": "b", "text": "The number of positional parameters (arguments) passed to the script"}, {"id": "c", "text": "The current line number"}, {"id": "d", "text": "The name of the script"}]', 'b', '$# returns the count of command line arguments provided to the executing script.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-12', 'mod-7', 'What is the purpose of the ''trap'' command in bash?', '[{"id": "a", "text": "To capture network packets"}, {"id": "b", "text": "To catch signals and execute clean-up code before exit"}, {"id": "c", "text": "To lock system users out of the console"}, {"id": "d", "text": "To enforce memory bounds on processes"}]', 'b', 'trap registers handlers (scripts/functions) that trigger when the shell receives specific signals (like SIGINT, EXIT, etc.).')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-13', 'mod-7', 'What does ''set -uo pipefail'' do?', '[{"id": "a", "text": "Exits on unbound variables and ensures pipelines return the first success exit status"}, {"id": "b", "text": "Exits on unbound variables and ensures pipelines return the exit status of the last command to fail"}, {"id": "c", "text": "Optimizes CPU pipeline performance"}, {"id": "d", "text": "Disables logging for pipe buffers"}]', 'b', 'set -u exits on references to undefined variables. pipefail makes a pipeline return the status of the rightmost command to fail, rather than the final command''s status.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-14', 'mod-7', 'What is the correct syntax to define a function named ''cleanup'' in bash?', '[{"id": "a", "text": "def cleanup():"}, {"id": "b", "text": "cleanup() {"}, {"id": "c", "text": "function cleanup: {"}, {"id": "d", "text": "cleanup() => {"}]', 'b', 'The standard syntax is either ''cleanup() { ... }'' or ''function cleanup { ... }''.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-15', 'mod-7', 'How do you pass arguments to a function inside a bash script?', '[{"id": "a", "text": "Pass them in parentheses: cleanup(arg1, arg2)"}, {"id": "b", "text": "Pass them as space-separated values: cleanup arg1 arg2, and access them as $1, $2 inside the function"}, {"id": "c", "text": "Define them in environment variables"}, {"id": "d", "text": "Functions do not support parameters"}]', 'b', 'In bash, functions accept positional parameters just like scripts, accessed via $1, $2, etc.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-16', 'mod-7', 'Which loop syntax is used to iterate over a list of items?', '[{"id": "a", "text": "for item in list; do ... done"}, {"id": "b", "text": "foreach item (list) { ... }"}, {"id": "c", "text": "while item in list: ..."}, {"id": "d", "text": "loop item over list; do ... done"}]', 'a', 'The for-in loop (for var in list; do ... done) is the standard syntax to iterate over expansion lists.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-17', 'mod-7', 'What does ''local'' keyword do inside a function?', '[{"id": "a", "text": "Forces the function to run locally on host"}, {"id": "b", "text": "Restricts variable scope to the function, preventing pollution of global namespace"}, {"id": "c", "text": "Sets variables to read-only"}, {"id": "d", "text": "Marks variables for storage in the filesystem"}]', 'b', 'Variables declared with local are only visible inside the function stack frame, protecting global state.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-18', 'mod-7', 'Which command is used to evaluate numerical arithmetic in bash?', '[{"id": "a", "text": "expr"}, {"id": "b", "text": "$(( ))"}, {"id": "c", "text": "Both expr and $(( ))"}, {"id": "d", "text": "calc"}]', 'c', 'Arithmetic can be performed via the modern $(( expression )) syntax or the legacy expr utility.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-19', 'mod-7', 'How do you check if a file named ''app.conf'' exists and is a regular file?', '[{"id": "a", "text": "[ -d app.conf ]"}, {"id": "b", "text": "[ -f app.conf ]"}, {"id": "c", "text": "[ -e app.conf ]"}, {"id": "d", "text": "[ -r app.conf ]"}]', 'b', 'The -f operator checks if the file exists and is a regular file. -d checks for directories, -e checks for any existence.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);

INSERT INTO assessment_questions (id, module_id, question_text, options_json, correct_answer, explanation) VALUES
('aq-7-20', 'mod-7', 'What is the purpose of the ''shebang'' (e.g. #!/usr/bin/env bash) at the start of a script?', '[{"id": "a", "text": "It acts as a comment for the developer"}, {"id": "b", "text": "It tells the kernel which interpreter to use to run the script"}, {"id": "c", "text": "It makes the script read-only"}, {"id": "d", "text": "It checks for syntax errors before execution"}]', 'b', 'The shebang specifies the path to the interpreter executable (like bash, python, or perl) used to parse the file.')
ON DUPLICATE KEY UPDATE question_text=VALUES(question_text), options_json=VALUES(options_json), correct_answer=VALUES(correct_answer), explanation=VALUES(explanation);


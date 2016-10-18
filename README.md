# oilman
Easily restore a DB from the command line

```bash
mkdir ~/sql_backups
mount -t smbfs //GUEST:@192.168.14.15/SQL-Server_Backups ~/sql_backups

# Sample output from the `df` command, if SQL-Server_Backups is already mounted
# then it must be unmounted otherwise an error like below will occur:
# > mount_smbfs //192.168.14.15/SQL-Server_Backups sql_backups/
#
# Filesystem                                                           512-blocks       Used  Available Capacity    iused      ifree %iused  Mounted on
# /dev/disk1                                                            345703120  163250360  181940760    48%    1320133 4293647146    0%   /
# devfs                                                                       380        380          0   100%        658          0  100%   /dev
# /dev/disk0s4                                                          126500856   41515656   84985200    33%      94318   42505546    0%   /Volumes/BOOTCAMP
# map -hosts                                                                    0          0          0   100%          0          0  100%   /net
# map auto_home                                                                 0          0          0   100%          0          0  100%   /home
# /dev/disk2s2                                                          976099336  582844896  393254440    60%    4528028 4290439251    0%   /Volumes/EXTERNAL HD
# /dev/disk0s3                                                            1269536    1105712     163824    88%         55 4294967224    0%   /Volumes/Recovery HD
# //GUEST:@WE-readynas%20%28SMB%29._smb._tcp.local/SQL-Server_Backups 11691975936 4802775688 6889200248    42% 2401387842 3444600124   41%   /Volumes/SQL-Server_Backups
#
# Found shell script below that can dynamically unmount. I don't like reading shell script so re-write to ruby
#
#
# #!/bin/sh
# function mount_drive {
#   mkdir -p $2
#   mount_smbfs $1 $2
# }
#  
# drives_to_unmount=`df | awk '/mneedham@punedc02/ { print $6 }'`
#  
# if [ "$drives_to_unmount" != "" ]; then
#   echo "Unmounting existing drives on punedc02: \n$drives_to_unmount"
#   umount $drives_to_unmount
# fi
#  
# mount_drive //mneedham@punedc02/media /Volumes/punedc02_media
# mount_drive //mneedham@punedc02/shared /Volumes/punedc02_shared
```

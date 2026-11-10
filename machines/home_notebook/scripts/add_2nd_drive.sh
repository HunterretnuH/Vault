# 1. Add crypttab entry `data_drive UUID=46c2cbee-bf35-4792-93e2-7ea7d52604a8 none luks`
# 2. Add /mnt/Data and link to ~/Desktop/Data
# 3. Add fstab entry. `data_drive UUID=46c2cbee-bf35-4792-93e2-7ea7d52604a8 none luks`
#  Backup: //truenas.my-host.org/Family  /mnt/Remote/NAS/Media/Family  cifs  credentials=/home/hunter/.smb-credentials/truenas-family-media,uid=1000,gid=1000,iocharset=utf8,file_mode=0770,dir_mode=0770,vers=3.1.1,_netdev,noauto  0  0

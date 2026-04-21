# Ranger config

## How to update rifle.conf

1. Change filename of `rifle.conf` to `rifle.conf.backup` and copy new config:
    ```bash
    mv rifle.conf rifle.conf.backup
    ranger --copy-config=file
    ```
2. Run diff and check what changes I've made to orignal `rifle.conf`:
    ```bash
    vim -d rifle.conf.backup rifle.conf.orig
    ```
3. Apply found changes in point 3 to new rifle.conf.
4. Remove old files and create new `.orig`:
    ```bash
    rm -f rifle.conf.backup rifle.conf.orig
    mv rifle.conf rifle.conf.tmp
    ranger --copy-config=file
    cp rifle.conf rifle.conf.orig
    mv rifle.conf.tmp rifle.conf 
    ```

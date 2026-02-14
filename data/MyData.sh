#!/bin/bash
# vi: foldmethod=marker foldmarker=#{,#} nowrap

#{ FUNCTIONS

    source ./lib/common_functions.sh $BASH_SOURCE

    function print_help() { #{
        echo -e "MyData.sh -(h|e [-D <export_dir>]|i) [-d <data_path>] [<machine>]\n" 
        echo -e "Description:" 
        echo -e "    Simple utility used to import and export user data.\n"
        echo -e "    NOTE: <machine> is required if \$MY_MACHINE is not set. <machine> is directory name inside ./machines/ directory"
        echo -e "    NOTE: Please run shis script only directly from script directory i.e. ./MyPC.sh.\n"
        echo -e "Options:" 
        echo -e "    -h, --help             - prints help message"
        echo -e "    -e, --export           - exports user data"
        echo -e "        -D, --export-dir   - use this path instead of default ~/ (doesn't work with absolute paths)"
        echo -e "    -i, --import           - imports user data"
        echo -e "    -d, --data-path        - package to import/export absolute path, default is: \$(pwd)./machines/<machine>/data"
    } #}

    function file() { #{
        # $1 - path to dir or file (relative to USER_HOME_DIR)
        FS_NODE=$1
        FS_NODE_LIST+=("$FS_NODE")

        if [ -n "$IMPORT" ]; then
            if [ ! -e $FS_NODE ]; then
                echo -e "${PREFIX}\t\tError: Path $FS_NODE not found. Skipped adding to list."
            fi
        fi
        echo -e "${PREFIX}\tAdded $FS_NODE to list."
    } #}

    function dir() { #{
        file $@
    } #}

    function link() { #{
        file $@
    } #}

    function import_data() { #{
        tar -cf - -C ~/ ${FS_NODE_LIST[@]} |                                       \
            pv -s $(du -sb ${FS_NODE_LIST[@]} | awk '{sum+=$1} END {print sum}') > \
            ${DATA_PATH}.tar
    } #}

    function export_data() { #{
        pv ${DATA_PATH}.tar | tar -x -C $EXPORT_DIR
    } #}

    function run() { #{
        if   [ -n "$EXPORT" ]; then
        section "Exporting data..."
            export_data 
        elif [ -n "$IMPORT" ]; then
        section "Importing data..."
            import_data 
        fi
        section "\033[32;1mFinished succesfully!\033[0m"
    } #}

    function initialize_globals() { #{
        # usage: initialize_globals $@

        PREFIX="    MyData: "

        EXPORT=""
        IMPORT=""


        if [ $# -gt 4 ]; then
            echo -e "${PREFIX}Error: Too many arguments were used."
            print_help
            exit 1
        elif [ $# -eq 0 ]; then
            print_help; exit 1;
        fi
        

        [ $# -eq 1 ] && ARG_MIN_IDX=0 || ARG_MIN_IDX=1  # Used to not process <machine> in this loop
        while [ $# -ne $ARG_MIN_IDX ]
        do
            KEY=$1
            case "$KEY" in
                -e|--export)        EXPORT=TRUE;;
                -D|--export-dir)    EXPORT_DIR=$2; shift;;
                -i|--import)        IMPORT=TRUE;;
                -d|--data-path)     DATA_PATH=$2; shift ;;
                -h|--help)          print_help; exit 0;;
                --)                 shift; break ;;
                *)                  echo "${PREFIX}Error: Parameter not recognized."; print_help; exit 1 ;;
            esac
            shift
        done

        MACHINE=${1:-$MY_MACHINE}
        if [ -z "$MACHINE" ]; then
            echo "${PREFIX}Error: MY_MACHINE is not set and <machine> was not provided."
            exit 1
        fi

        FS_NODES_LIST=()
        DATA_PATH=${DATA_PATH:-$(pwd)/machines/$MACHINE/data}
            # TODO: Add option to create packages with name which includes date and time 
            # or date and next number. May be useful: mktemp -d machineXXX)

        # Create new machine if it doesn't exist
        if [[ ! -d ./machines/$MACHINE || ! -f ./machines/$MACHINE/conf.sh ]]; then
            mkdir -p ./machines/$MACHINE
            cp ./conf.sh.template ./machines/$MACHINE/conf.sh
        fi

        source ./machines/$MACHINE/conf.sh

        EXPORT_DIR=${EXPORT_DIR:-"/home/$USER"}
        cd $EXPORT_DIR
    } #}

#} FUNCTIONS

#{ DATA TO IMPORT/EXPORT
#
    initialize_globals $@

    section "Adding files to list"
        if [ -n "$XDG_DESKTOP_DIR" ]; then
            dir Desktop
        fi

        if [ -n "$SSH" ]; then
            dir .ssh
        fi

        if [ -n "$WIREGUARD" ]; then
            dir .wg
        fi

        if [ -n "$REMOTE_DIR" ]; then
            dir .Remote
        fi

        if [ -n "$FIREFOX" ]; then
            dir .mozilla
        fi

        run

#}

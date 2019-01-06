# using this to learn the arcane and mystical ways of arguments


# /* no parameters, displays the help message */
#
function show_help(){
    clear
    showbanner
    echo "install.sh, version $SCRIPT_VERSION";
    echo "Usage example:";
    echo "install.sh (-p|--project) string [(-h|--help)] [(-n|--net) int] [(-c|--count) int] [(-r|--release) string] [(-w|--wipe)] [(-u|--update)] [(-x|--startnodes)]";
    echo "Options:";
    echo "-h or --help: Displays this information.";
    echo "-p or --project string: Project to be installed. REQUIRED.";
    echo "-n or --net: IP address type t be used (4 vs. 6).";
    echo "-c or --count: Number of masternodes to be installed.";
    echo "-r or --release: Release version to be installed.";
    echo "-s or --sentinel: Add sentinel monitoring for a node type. Combine with the -p option";
    echo "-w or --wipe: Wipe ALL local data for a node type. Combine with the -p option";
    echo "-u or --update: Update a specific masternode daemon. Combine with the -p option";
    echo "-r or --release: Release version to be installed.";
    echo "-x or --startnodes: Start masternodes after installation to sync with blockchain";
    exit 1;
}


# source the default and desired crypto configuration files
function source_config() {

    SETUP_CONF_FILE="${SCRIPTPATH}/config/${project}/${project}.env"

    # first things first, to break early if things are missing or weird
    check_distro

    if [ -f ${SETUP_CONF_FILE} ]; then
        echo "Script version ${SCRIPT_VERSION}, you picked: $(tput bold)$(tput setaf 2) ${project} $(tput sgr0), running on Ubuntu ${VERSION_ID}"
        echo "apply config file for ${project}"	&>> ${SCRIPT_LOGFILE}
        source "${SETUP_CONF_FILE}"

        # count is from the default config but can ultimately be
        # overwritten at runtime
        if [ -z "${count}" ]
        then
            count=${SETUP_MNODES_COUNT}
            echo "No number given, installing default number of nodes: ${SETUP_MNODES_COUNT}" &>> ${SCRIPT_LOGFILE}
        fi

        # release is from the default project config but can ultimately be
        # overwritten at runtime
        if [ -z "$release" ]
        then
            release=${SCVERSION}
            echo "release empty, setting to project default: ${SCVERSION}"  &>> ${SCRIPT_LOGFILE}
        fi

        # net is from the default config but can ultimately be
        # overwritten at runtime
        if [ -z "${net}" ]; then
            net=${NETWORK_TYPE}
            echo "net EMPTY, setting to default: ${NETWORK_TYPE}" &>> ${SCRIPT_LOGFILE}
        fi

        # main block of function logic starts here
        # if update flag was given, check if all required mn-helper files exist
        if [ "$update" -eq 1 ]; then
            if [ ! -f ${MNODE_DAEMON} ]; then
                echo "UPDATE FAILED! Daemon hasn't been found. Please try the normal installation process by omitting the upgrade parameter."
                exit 1
            fi
            if [ ! -f ${MNODE_HELPER}_${CODENAME} ]; then
                echo "UPDATE FAILED! Masternode activation file ${MNODE_HELPER}_${CODENAME} hasn't been found. Please try the normal installation process by omitting the upgrade parameter."
                exit 1
            fi
            if [ ! -d ${MNODE_DATA_BASE} ]; then
                echo "UPDATE FAILED! ${MNODE_DATA_BASE} hasn't been found. Please try the normal installation process by omitting the upgrade parameter."
                exit 1
            fi
        fi

        echo "************************* Installation Plan *****************************************"
        echo ""
        if [ "$update" -eq 1 ]; then
            echo "I am going to update your existing "
            echo "$(tput bold)$(tput setaf 2) => ${project} masternode(s) in version ${release} $(tput sgr0)"
        else
            echo "I am going to install and configure "
            echo "$(tput bold)$(tput setaf 2) => ${count} ${project} masternode(s) in version ${release} $(tput sgr0)"
        fi
        echo "for you now."
        echo ""
        if [ "$update" -eq 0 ]; then
            # only needed if fresh installation
            echo "You have to add your masternode private key to the individual config files afterwards"
            echo ""
        fi
        echo "Stay tuned!"
        echo ""
        # show a hint for MANUAL IPv4 configuration
        if [ "${net}" -eq 4 ]; then
            NETWORK_TYPE=4
            echo "WARNING:"
            echo "You selected IPv4 for networking but there is no automatic workflow for this part."
            echo "This means you will have some mamual work to do to after this configuration run."
            echo ""
            echo "See the following link for instructions how to add multiple ipv4 addresses on vultr:"
            echo "${IPV4_DOC_LINK}"
        fi
        # sentinel setup
        if [ "$sentinel" -eq 1 ]; then
            echo "I will also generate a Sentinel configuration for you."
        fi
        # start nodes after setup
        if [ "$startnodes" -eq 1 ]; then
            echo "I will start your masternodes after the installation."
        fi
        echo ""
        echo "A logfile for this run can be found at the following location:"
        echo "${SCRIPT_LOGFILE}"
        echo ""
        echo "*************************************************************************************"
        sleep 5

        # main routine
        if [ "$update" -eq 0 ]; then
            prepare_mn_interfaces
            swaphack
        fi
        install_packages
        print_logo
        build_mn_from_source
        if [ "$update" -eq 0 ]; then
            create_mn_user
            create_mn_dirs
            # sentinel setup
if [ "$sentinel"
                echo "* Sentinel setup chosen" &>> ${SCRIPT_LOGFILE}
                create_sentinel_setup
            fi
            configure_firewall
            create_mn_configuration
            create_control_configuration
            create_systemd_configuration
fi
        set_permissions
        cleanup_after
        showbanner
        final_call
        #if [ "$update" -eq 1 ]; then
            # need to update the systemctl daemon, else an error will occur when running `systemctl enable` on a changed systemd process
        #    systemctl daemon-reload
        #fi
    else
        echo "required file ${SETUP_CONF_FILE} does not exist, abort!"
        exit 1
    fi

}


# Declare vars. Flags initalizing to 0.
wipe=0;
debug=0;
update=0;
sentinel=0;
startnodes=0;

# Execute getopt
ARGS=$(getopt -o "hp:n:c:r:wsudx" -l "help,project:,net:,count:,release:,wipe,sentinel,update,debug,startnodes" -n "install.sh" -- "$@");

#Bad arguments
if [ $? -ne 0 ];
then
    help;
fi

eval set -- "$ARGS";

while true; do
    case "$1" in
        -h|--help)
            shift;
            help;
            ;;
        -p|--project)
            shift;
                    if [ -n "$1" ];
                    then
                        project="$1";
                        shift;
                    fi
            ;;
        -n|--net)
            shift;
                    if [ -n "$1" ];
                    then
                        net="$1";
                        shift;
                    fi
            ;;
        -c|--count)
            shift;
                    if [ -n "$1" ];
                    then
                        count="$1";
                        shift;
                    fi
            ;;
        -r|--release)
            shift;
                    if [ -n "$1" ];
                    then
                        release="$1";
                        SCVERSION="$1"
                        shift;
                    fi
            ;;
        -w|--wipe)
            shift;
                    wipe="1";
            ;;
        -s|--sentinel)
            shift;
                    sentinel="1";
            ;;
        -u|--update)
            shift;
                    update="1";
            ;;
        -d|--debug)
            shift;
                    debug="1";
            ;;
        -x|--startnodes)
            shift;
                    startnodes="1";
            ;;

        --)
            shift;
            break;
            ;;
    esac
done

# Check required arguments
if [ -z "$project" ]
then
    show_help;
fi

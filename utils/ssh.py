import sys
import logging
import subprocess

logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.DEBUG)


def parse_args():
    """
    Check whether the arguments given from the command line make any sense
    """
    len_args = len(sys.argv)
    if sys.argv[1] == "--help" or sys.argv[1] == "-h":
        sys.exit(logging.info(
            "Usage: python ssh.py <app_name> <optional_ssh_key>"))
    else:
        if len_args == 2:
            ssh_into_container(sys.argv[1])
        elif len_args == 3:
            ssh_into_container(sys.argv[1], key=sys.argv[2])
        else:
            sys.exit(logging.warning("Too few or too many arguments given"))


def ssh_into_container(container_name, key="insecure_key"):
    """
    SSH into container provided by arguments container_name and optional key
    """
    container_id = get_container_id(container_name)
    container_ip = get_container_ip(container_id)

    command = "ssh -i config/ssh/%s root@%s" % (key, container_ip)

    try:
        subprocess.call(command, shell=True)
    except:
        sys.exit(
            logging.warning("An error occured while issuing the command "
                            "'ssh'"))


def get_container_id(container_name):
    """
    This will get the container id from the docker ps output
    """
    try:
        output = subprocess.check_output('docker ps', shell=True)
    except:
        sys.exit(
            logging.warning("An error occured while issuing the command "
                            "'docker ps'"))

    container_id = [line.split()[0] for line in output.splitlines()
                    if container_name in line]

    if len(container_id) == 1:
        return container_id[0]
    elif len(container_id) < 1:
        sys.exit(
            logging.warning("Provided container name '%s' not found"
                            % container_name))
    elif len(container_id) > 1:
        sys.exit(
            logging.warning("Too many containers with name '%s' found, "
                            "please specify the correct container name"
                            % container_name))


def get_container_ip(container_id):
    """
    Get the container ip address provided with the container id
    """
    command = 'docker inspect -f "{{ .NetworkSettings.IPAddress }}" %s' \
        % container_id

    try:
        output = subprocess.check_output(command, shell=True).splitlines()
    except:
        sys.exit(
            logging.warning("An error occured while issuing the command "
                            "'docker inspect'"))

    if output > 1:
        return output[0]
    else:
        sys.exit(
            logging.warning("Could not get an ip address for container "
                            "with id '%s'" % container_id))


if __name__ == "__main__":
    parse_args()

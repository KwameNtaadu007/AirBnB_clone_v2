#!/usr/bin/python3
""" A Fabric script to delete out-of-date archives, using the
    function do_clean, based on the file 3-deploy_web_static.py """
import os
import glob
import shutil
from fabric import Connection, Config
from paramiko import SSHConfig


def do_clean(number=0):
    ssh_config = SSHConfig()
    with open(os.path.expanduser('~/.ssh/config')) as f:
        ssh_config.parse(f)

    for host in ['34.201.61.30', '3.90.83.253']:
        print(f'Connecting to {host}')
        c = Connection(host, config=Config(overrides={'host': host}))
        with c.cd('/data/web_static/releases'):
            release_archives = sorted(glob.glob('archive*.tar.gz'))
            to_remove = len(release_archives) - number
            for archive in release_archives[:to_remove]:
                print(f'Deleting {archive} from {host}')
                c.run(f'rm -f {archive}')

        with c.cd('/data/versions'):
            version_archives = sorted(glob.glob('archive*.tar.gz'))
            to_remove = len(version_archives) - number
            for archive in version_archives[:to_remove]:
                print(f'Deleting {archive} from {host}')
                c.run(f'rm -f {archive}')

        c.close()


if __name__ == '__main__':
    do_clean(number=2)



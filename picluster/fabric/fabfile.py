from fabric.api import *
from fabric.colors import green

env.skip_bad_hosts = True
env.hosts = [
    'ubuntu@control01.picluster', 
    'ubuntu@worker01.picluster', 
    'ubuntu@worker02.picluster'
            ]
 
env.password = "ubuntu"
 
@parallel
def check():
    # check host type
    host_type()
 
    # check diskspace
    diskspace()
 
@parallel
def cmd(command):
     if run(command).failed:
         sudo(command)

@parallel
def sudocmd(command):
    sudo(command)

@serial
def scmd(serialcommand):
    if run(serialcommand).failed:
        sudo(serialcommand)

@parallel
def allshutdown():
    sudo("shutdown -t 1") # shutdown in 1 min
 
@parallel
def allreboot():
    sudo("shutdown -r -t 1") # reboot in 1 min
 
@parallel
def allcancel():
    sudo("shutdown -c") # cancel the last shutdown command
 
@parallel
def alldate():
    run("date +\"Date : %d/%m/%Y Time : %H.%M.%S\"") # show Time and Date

@parallel
def file_send(localpath, remotepath):
    put(localpath, remotepath, use_sudo=True)

@parallel
def file_get(remotepath, localpath):
    get(remotepath, localpath + "." + env.host)

@parallel
def cputemp():
    run("cat /sys/class/thermal/thermal_zone0/temp")

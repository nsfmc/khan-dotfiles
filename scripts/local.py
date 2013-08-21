import os
import sys


def homebrew_path_check():
    """determine how best to get /usr/local/bin to 'win' in path battles

    by default on vanilla osx starting with 10.5, /etc/paths is sourced by
    `/usr/libexec/path_helper` to build the default system $PATH. Rearranging
    this file results in higher paths taking precedence.

    exit codes:
        0: if ok
        1: change dotfiles
        3: to change /etc/paths
    """

    def local_first(pth):
        if pth.find('/usr/local/bin') > -1 and pth.find('/usr/bin') > -1:
            return pth.find('/usr/local/bin') < pth.find('/usr/bin')
        return False

    exported_first = local_first(os.environ.get('PATH'))
    if exported_first:
        # who cares how this happened, don't need to futz with /etc/paths
        sys.stdout.write('ok')
        return

    if os.path.exists('/etc/paths'):  # on osx this defines default paths
        with open('/etc/paths') as path_fd:
            sys_paths = path_fd.read()
        exported_via_path_helper = local_first(sys_paths)
        if not exported_via_path_helper:
            sys.stdout.write('paths')
            return  # go ahead and change /etc/paths
    # just change a dotfile
    sys.stdout.write('dotfile')
    return

if __name__ == '__main__':
    homebrew_path_check()
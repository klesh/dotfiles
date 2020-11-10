import os
from ranger.core.loader import CommandLoader
from ranger.api.commands import Command
from ranger.gui.widgets import Widget
from ranger.gui.widgets.browsercolumn import BrowserColumn


Widget.vcsstatus_symb = {
    'conflict': (
        'X ', ['vcsconflict']),
    'untracked': (
        '? ', ['vcsuntracked']),
    'deleted': (
        '- ', ['vcschanged']),
    'changed': (
        '+ ', ['vcschanged']),
    'staged': (
        '* ', ['vcsstaged']),
    'ignored': (
        '· ', ['vcsignored']),
    'sync': (
        '✓ ', ['vcssync']),
    'none': (
        '  ', []),
    'unknown': (
        '! ', ['vcsunknown']),
}


Widget.vcsremotestatus_symb = {
    'diverged': (
        ' Y', ['vcsdiverged']),
    'ahead': (
        ' >', ['vcsahead']),
    'behind': (
        ' <', ['vcsbehind']),
    'sync': (
        ' =', ['vcssync']),
    'none': (
        ' ⌂ ', ['vcsnone']),
    'unknown': (
        ' !', ['vcsunknown']),
}


def wrap_draw_vcsstring_display(origin):
    def _draw_vcsstring_display(*args, **kwargs):
        vcsstring = origin(*args, **kwargs)
        if vcsstring and vcsstring[0] and vcsstring[0][0] == '  ':
            vcsstring[0][0] = '    '
        return vcsstring
    return _draw_vcsstring_display


BrowserColumn._draw_vcsstring_display = wrap_draw_vcsstring_display(BrowserColumn._draw_vcsstring_display)


class extracthere(Command):
    def execute(self):
        """ Extract copied files to current directory """
        copied_files = tuple(self.fm.copy_buffer)

        if not copied_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        one_file = copied_files[0]
        cwd = self.fm.thisdir
        original_path = cwd.path
        au_flags = ['-X', cwd.path]
        au_flags += self.line.split()[1:]
        au_flags += ['-e']

        self.fm.copy_buffer.clear()
        self.fm.cut_buffer = False
        if len(copied_files) == 1:
            descr = "extracting: " + os.path.basename(one_file.path)
        else:
            descr = "extracting files from: " + os.path.basename(one_file.dirname)
        obj = CommandLoader(args=['aunpack'] + au_flags \
                + [f.path for f in copied_files], descr=descr)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)


class compress(Command):
    def execute(self):
        """ Compress marked files to current directory """
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        original_path = cwd.path
        parts = self.line.split()
        au_flags = parts[1:]

        descr = "compressing files in: " + os.path.basename(parts[1])
        obj = CommandLoader(args=['apack'] + au_flags + \
                [os.path.relpath(f.path, cwd.path) for f in marked_files], descr=descr, read=True)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

    def tab(self, tabnum):
        """ Complete with current folder name """

        extension = ['.zip', '.tar.gz', '.rar', '.7z']
        return ['compress ' + os.path.basename(self.fm.thisdir.path) + ext for ext in extension]


class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        import subprocess
        import os.path
        if self.quantifier:
            # match only directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        else:
            # match files and directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
            -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


class fzf_edit(Command):
    """
    :fzf_open

    edit a file using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        import subprocess
        import os.path
        # match files and directories
        command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune \
        -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            self.fm.edit_file(fzf_file)

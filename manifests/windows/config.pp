# == Class profile_base::windows::config
#
# This class is called from profile_base for service config.
#
class profile_base::windows::config {
  shortcut { 'C:\Users\Admin\Desktop/myshortcut.lnk':
    target => 'C:/Windows/system32/cmd.exe',
  }
}

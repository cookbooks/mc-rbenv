FTPMODE=auto
MAIL=/usr/mail/${LOGNAME:?}
MANPATH=/opt/local/gcc47/man:/opt/local/java/sun6/man:/opt/local/lib/perl5/man:/opt/local/lib/perl5/vendor_perl/man:/opt/local/gnu/man:/opt/local/man:/usr/share/man
PAGER=less
PATH=/opt/local/gnu/bin:/opt/local/bin:/opt/local/sbin:/usr/bin:/usr/sbin

export FTPMODE MAIL MANPATH PAGER PATH

# hook man with groff properly
if [ -x /opt/local/bin/groff ]; then
  alias man='TROFF="groff -T ascii" TCAT="cat" PAGER="less -is" /usr/bin/man -T -mandoc'
fi

# help ncurses programs determine terminal size
export COLUMNS LINES

HOSTNAME=`/usr/bin/hostname`
HISTSIZE=1000

if [ -d "$HOME/profile.d" ] ; then
  for file in $HOME/profile.d/* ; do
    . $file
  done
fi
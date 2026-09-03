# ssh

`config` is symlinked to `~/.ssh/config` by `setup.sh`. It holds only reusable
defaults.

Everything host-specific goes in `~/.ssh/config.d/*.conf` — **untracked**,
because hostnames, IPs and even key filenames are work/customer-internal and
this repo has a public remote. `setup.sh` only creates the directory.

Files are read in lexical order and the first value for a keyword wins, so keep
the blocks specific.

Template for a new host (`~/.ssh/config.d/40-example.conf`, mode 0600):

    Host example.com
        User git
        IdentityFile ~/.ssh/<keyname>
        IdentitiesOnly yes

`IdentitiesOnly yes` plus exactly one `IdentityFile` per host is mandatory, not
optional tidiness: without it ssh also offers every key in the agent *and* every
default `~/.ssh/id_*`, which can exceed sshd's `MaxAuthTries` (default 6) on
forge and Gerrit hosts — you get "Too many authentication failures" before the
correct key is ever tried.

## Passphrases

Passphrase-less keys need nothing beyond the block above. Encrypted keys prompt
once through `ksshaskpass`; tick **Remember password** and the passphrase is
stored in the KDE wallet (`kdewallet`), so it is never asked again — in the
Hyprland session or a Plasma session. See `config/environment.d/20-ssh-askpass.conf`
for how that is wired up and why.

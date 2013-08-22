# Khan-Dotfiles

> I was there when Captain Beefheart started up his first band.
> I told him, "Don't do it that way. You'll never make a dime."

*--James Murphy*

## What this does

Khan-dotfiles is a very ambitious project. It attempts to do three things:

1. install applications and code your computer needs (packages)
2. configure those packages and set useful defaults (dotfiles)
3. set up auth tokens for github, kiln, etc (authentication)

right now, you sort of need to trust that it will do the right thing which is
something of a tall order if, say, you've already been using your computer
productively for months.

but the goal is that you will be able to opt into each of these things at
various levels of granularity which are appropriate for you at this very
moment!

## More info

Configuration files, and setup scripts, for Khan Academy website
developers.  A lot of what's here is Khan Academy-specific:

- Vim filetype plugins conforming to Khan Academy's style guide
- tell ack to skip crap that the deploy script litters
  (eg. combined/compressed CSS/JS files)
- Kiln authentication stuff
- a [pre-commit linter](https://github.com/Khan/khan-linter)

and the rest of it just contains generally useful things, such as

- handy `git` aliases such as `git graph`
- having `hg` pipe commands with large output to `less`
- useful Mercurial aliases and extensions such as `shelve` (similar to
  `git stash`) and `record` (similar to `git add -p && git commit`)

This is meant to complement [the dev setup on the Khan Academy Forge](https://sites.google.com/a/khanacademy.org/forge/for-khan-employees/-new-employees-onboard-doc/developer-setup).
The setup scripts here assume you have done the initial setup on that
Forge page (installing npm, etc) before running commands here.

Setup
-----
Clone this repo somewhere (I recommend into a `~/khan/devtools`
directory, but it doesn't really matter), and then run `make` in
the cloned directory:

    mkdir -p ~/khan/devtools
    cd ~/khan/devtools
    git clone git://github.com/Khan/khan-dotfiles.git
    cd khan-dotfiles
    make

This will install your system: installing executables, python
libraries, dotfiles, etc.  It will not overwrite any of your existing
dotfiles but will emit a warning if it sees something it doesn't
understand.

This script is idempotent, so it should be safe to run it multiple times.

You may wish to install
[autojump](https://github.com/joelthelion/autojump) if you're a
frequent user of the terminal to navigate the filesystem.

Hello
-----
Originally extracted from [David's
dotfiles](http://github.com/divad12/dotfiles), with commits and lines
here and there stolen from [Jamie](http://github.com/phleet/dotfiles),
[Desmond](https://github.com/dmnd), and others.  Non-dotfile config
files, and the setup script, written by Craig Silverstein.

Pull requests are welcome!

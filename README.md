{Redcar}
========

[http://redcareditor.com/](http://redcareditor.com/)

## FORK!

This fork of redcar doesn't reflect the current state of master on redcar/redcar. I rolled back
to the 0.13 release before branching. I did this mostly because I had started using 0.13, and I
wanted to fix some things, and tweak some things and add some things. Not all of those things are
consistent with the current redcar roadmap.

## DESCRIPTION

A Ruby text editor.

 * written in Ruby from the ground up
 * runs on JRuby (a fast, compatible Ruby implementation)
 * is cross-platform (Linux, Mac OS X, Windows)
 * highly extensible

Some Redcar features:

 * supports Textmate themes and snippets
 * split screen mode
 * syntax checking for many languages
 * built in REPL for Ruby, plugins for Groovy, Clojure and Mirah.

Some (current) limitations:

 * Only supports UTF-8 file encodings (and therefore ASCII)

![alt text](http://redcareditor.com/images/redcar-4-thumb.png "Title")
![alt text](http://redcareditor.com/images/redcar-1-thumb.png "Title")

## INSTALLATION

    $ gem install redcar

for more details, see [User Guide: Installation](https://github.com/redcar/redcar/wiki/Installation)

## USAGE

Run

    $ redcar --help

To see full usage details.

## PROBLEMS?

* Irc at #redcar on irc.freenode.net
* Mailing list at http://groups.google.com/group/redcar-editor

## LICENSE

Redcar is copyright 2007-2012 Daniel Lucraft and contributors.
It is licensed under the GPLv2. See the included LICENSE file for details.

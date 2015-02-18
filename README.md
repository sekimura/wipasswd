# wipasswd

> Mac OS X tool to show Wifi Passwords in Keychain

## Usage

```
$ wipasswd
SSID: NETGEAR99
PASS: Tr0ub4dor&3
```
It does use current SSID with no arguments.

You can specify SSID as an agument too.

```
$ wipasswd NETGEAR99
SSID: NETGEAR99
PASS: Tr0ub4dor&3
```

And you'll see a prompt to use "System" keychain. Enter your Username and Password.

![screen-capture.gif](https://raw.githubusercontent.com/sekimura/wipasswd/master/screen-capture.gif)


## Install

Method 1: Install from my tap repo

```
$ brew install https://raw.github.com/sekimura/homebrew-tap/master/wipasswd.rb
```

Method 2: Use [brew tap](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/brew-tap.md)

```
$ brew tap sekimura/tap
$ brew install sekimura/tap/wipasswd
```

## License

MIT © [Masayoshi Sekimura](http://sekimura.org)


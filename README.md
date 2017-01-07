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

First, clone this repo
```
$ git clone https://github.com/sekimura/wipasswd.git
$ cd wipasswod
```

To build binary, run make to build wipasswd binary

```
$ make
$ ./wipasswd
```

You can also use wipasswd.swift as a script file

```
$ chmod 755 ./wipasswd.swift
$ ./wipasswd.swift
```

If you don't have Xcode, you can still do th same with bash script.

```
$ ./wipasswd.bash
```

Enjoy!

## License

MIT © [Masayoshi Sekimura](https://www.sekimura.org)


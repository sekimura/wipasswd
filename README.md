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

```
$ git clone https://github.com/sekimura/wipasswd.git
$ cd wipasswod
$ make
```

## License

MIT © [Masayoshi Sekimura](https://www.sekimura.org)


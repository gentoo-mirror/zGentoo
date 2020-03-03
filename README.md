# ZappeL's - Gentoo portage overlay

---

## Installation

--

### Using layman (app-portage/layman)

Add zGentoo using layman:

```Bash
layman -o https://lab.retarded.farm/zappel/zGentoo/raw/master/repositories.xml -f -a zGentoo
```

Then run `layman -s zGentoo`

### Using local overlay

Create a `/etc/portage/repos.conf/zGentoo.conf` file containing

```Bash
[zGentoo]
location = /usr/local/portage/zGentoo
sync-type = git
sync-uri = https://lab.retarded.farm/zappel/zGentoo
priority=9999
```

Then run `emerge --sync`

## Colaboration

You can directly communicate with us using discord, just follow this invite link: [zGentoo (#zgentoo)](https://discord.gg/jMBFy56)

### Re-digesting all ebuilds

Please make sure BLAKE2 hashing algorythm is activated. (`emerge -a dev-python/pyblake2`)

```Bash
for ebuild in `find . -name *.ebuild -type f`; do ebuild $ebuild digest; done
```

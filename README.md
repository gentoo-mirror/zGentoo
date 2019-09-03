# ZappeL's - Gentoo portage overlay

---

## Installation

--

### via local overlays

Create a `/etc/portage/repos.conf/zGentoo.conf` file containing

```Bash
[zGentoo]
location = /usr/local/portage/zGentoo
sync-type = git
sync-uri = https://lab.retarded.farm/zappel/zGentoo
priority=9999
```

Then run `emerge --sync`

### via layman

Add via layman:

```Bash
layman -o https://lab.retarded.farm/zappel/zGentoo/raw/master/repositories.xml -f -a zGentoo
```

Then run `layman -s zGentoo`

## Colaboration

### Re-digest exiting ebuilds

```Bash
for ebuild in `find . -name *.ebuild -type f`; do ebuild $ebuild digest; done
```

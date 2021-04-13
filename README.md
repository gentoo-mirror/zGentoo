# ZappeL's - Gentoo portage overlay

---

## Installation

--

### Using repositories (eselect) - preferred method

To use this method, make sure you've emerged `app-eselect/eselect-repository` before.

To add the repo, just run:

```bash
eselect repository add zGentoo
```

Then run `emaint sync -r zGentoo` to sync it.

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

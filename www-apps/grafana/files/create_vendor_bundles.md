# Instructions to build vendor bundles for grafana

Instructions to build vendor bundles for __grafana::zGentoo__. As this is part of my privately maintained repo, please do not blame any non-working ebuilds or issues you've after using my overlay. Of course, if you want to contribute or just get in touch with me, join my discord server ([discord](https://discord.gg/f8xbb6g)) or use my maintainer email(you know where to find it).

---

## requirements

Make sure the following tools are installed.

- git (dev-vcs/git)
- go (dev-lang/go)
- yarn (sys-apps/yarn)

## preparations

Clone the desired \<version\> into a temporary space:

```bash
git clone https://github.com/grafana/grafana -b v<vsrion> /tmp/grafana
```

### create go vendors (approx. 14 MiB)

```bash
cd /tmp/grafana
go mod vendor && tar -c -I 'xz -9 -T0' -f ../vendor-grafana-`git describe --tags | sed -E "s/v([0-9.]+)/\1/g"`.tar.xz vendor
```

### create yarn vendor file (this is way bigger, approx. 220 MiB)

```bash
cd /tmp/grafana
echo -e "enableMirror: true\ncacheFolder: ./vendor_yarn" >> .yarnrc.yml
# only needed in grafana 8.x tree
#yarn set version stable
CYPRESS_INSTALL_BINARY=0 yarn cache clean --mirror && yarn install
tar -c -I 'xz -9 -T0' -f ../vendor_yarn-grafana-`git describe --tags | sed -E "s/v([0-9.]+)/\1/g"`.tar.xz vendor_yarn
```

### obtain licenses

INFO: _we're not using the golicense to do this, as it's outdated and broken - as it won't work in many circumstances like builds using __CGO__ or other external dependencies_

\(WARNING\): __this section is under construction!__

```bash
# ... tbd!
```

---

## Contribute

- [discord](https://discord.gg/f8xbb6g)

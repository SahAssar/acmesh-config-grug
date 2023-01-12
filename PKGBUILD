pkgname=acmesh-config-grug
pkgver() {
  # Use number of revisions and hash as version
  cd "$pkgname"
  printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}
pkgrel=1
arch=('any')
pkgdesc="acme.sh config for grug"
url="https://git.grug.se/admin/acmesh-config-grug"
license=('MIT')
depends=('acme.sh' 'server-config-grug' 'openssl')
makedepends=()
provides=()
conflicts=()
install="script.install"
package() {
  mkdir -p "$pkgdir/etc/systemd/system/"
  cp acmesh-update.path "$pkgdir/etc/systemd/system/"
  cp acmesh-update.timer "$pkgdir/etc/systemd/system/"
  cp acmesh-update.service "$pkgdir/etc/systemd/system/"

  mkdir -p "$pkgdir/etc/acmesh-config-grug"
  cp update-certs.sh "$pkgdir/etc/acmesh-config-grug/"

  mkdir -p "$pkgdir/usr/share/acme.sh/dnsapi/"
  cp dns_local_file.sh "$pkgdir/usr/share/acme.sh/dnsapi/"

  mkdir -p "$pkgdir/var/acme-challenge/"
  cp example.com "$pkgdir/var/acme-challenge/"
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic meson

DESCRIPTION="EGLStream-based Wayland external platform"
HOMEPAGE="https://github.com/NVIDIA/egl-wayland"
SRC_URI="https://github.com/NVIDIA/egl-wayland/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	dev-libs/wayland
	!<x11-drivers/nvidia-drivers-470.57.02[wayland(-)]"
DEPEND="
	${RDEPEND}
	gui-libs/eglexternalplatform
	virtual/opengl"
BDEPEND="dev-util/wayland-scanner"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.6-remove-werror.patch
)

src_configure() {
	# EGLStream is not intended for X11, always build without (bug #777558)
	append-cppflags -DEGL_NO_X11

	meson_src_configure
}

src_install() {
	meson_src_install

	insinto /usr/share/egl/egl_external_platform.d
	doins "${FILESDIR}"/10_nvidia_wayland.json
}

pkg_postinst() {
	if has_version "<x11-drivers/nvidia-drivers-391"; then
		ewarn "<=nvidia-drivers-390.xx may not work properly with this version of"
		ewarn "egl-wayland, it is recommended to use nouveau drivers for wayland."
	fi
}

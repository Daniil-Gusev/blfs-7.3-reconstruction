# BLFS 7.3 Reconstruction

This repository is a reconstruction of Beyond Linux From Scratch (BLFS) as it
stood in early August 2013, immediately before the LFS/BLFS project entered
the release freeze that led to LFS-7.4 and BLFS-7.4. BLFS-7.3 itself was
never published as a numbered release; LFS jumped from 7.3 directly to 7.4.
This repository reconstructs the state of the book, source packages, and
patches as they existed at that specific point.

**Read the book: https://daniil-gusev.github.io/blfs-7.3-reconstruction/**

All checksums inside the book and in the package tables are unedited,
exactly as published in 2013 — they are what you verify a downloaded package
against. Download links are a different story: the book still shows the
original 2013 URLs, but many of those have since gone dead. In the package
tables, dead links have been replaced with working mirrors so the packages
can actually be re-downloaded today; the checksums next to them are still
the original ones, so a package fetched from a new link is verified against
the same hash as it would have been in 2013. Cross-check the book's links
against the [package tables](#package-tables) in this repository before
building.

## Why this snapshot matters

On August 3, 2013, Bruce Dubbs (LFS project lead) announced on the LFS and
BLFS development mailing lists that both books had caught up with upstream
and that a release freeze would begin on August 15, targeting LFS-7.4-rc1 and
a September 1 release:

> From: Bruce Dubbs <bruce.dubbs@gmail.com>
> To: LFS Developers Mailinglist <lfs-dev@linuxfromscratch.org>, BLFS Development List <blfs-dev@linuxfromscratch.org>
> Subject: [blfs-dev] Planning ahead
> Date: Sat, 03 Aug 2013 18:07:43 -0500
> List-archive: <http://linuxfromscratch.org/pipermail/blfs-dev>
> List-id: BLFS Development List <blfs-dev.linuxfromscratch.org>
>
> We have reached a milestone. The SVN versions of both LFS and BLFS are now
> up to date. There are no major outstanding issues that need to be fixed.
>
> There are a couple of minor changes that I have to LFS, but those will be
> committed soon, but are not critical. KDE is slightly out of date, but a
> new version is due anyway in the next two weeks.
>
> Of course, upstream will continue to release additional updates and we
> need to stay on top of that, but keeping up is a lot less problem than
> getting caught up from being behind on literally hundreds of packages.
>
> With that in mind, I would like to freeze LFS (mostly) on August 15 and
> release LFS-7.4-rc1. The target date for LFS-7.4 will be 1 September.
>
> During the freeze period, some packages may be updated, but not gcc,
> binutils, or glibc. Any update in the freeze period will be considered by
> the impact to the rest of the books - both LFS and BLFS.
>
> In that two week period, beyond normal fixes, I propose to start
> rebuilding BLFS and marking packages for lfs74. Shortly after the LFS
> release, I'd like to produce a 'stable' BLFS-7.4 with all packages in BLFS
> tested against the new LFS. Then sometime in September we can release
> BLFS-7.4.
>
> Comments?
>
> -- Bruce

The mail states plainly that as of August 3, 2013 both books were already
complete and up to date, and that BLFS-7.4 would only be a re-tagging and
verification pass on top of what already existed. The snapshot captured in
this repository, taken on August 4, 2013, sits inside that window: it is the
content the mail describes as already finished, one day before the toolchain
freeze took effect, and roughly two weeks before LFS-7.4-rc1 and about four
weeks before the eventual BLFS-7.4 release in September.

This makes it the last point where the "7.3 line" of the book can be
reconstructed as an internally consistent, complete set: every package in it
was built and tested against LFS-7.3's toolchain, not against the toolchain
that BLFS-7.4 was later re-verified against.

That toolchain distinction is the second reason this snapshot matters.
LFS-7.3 was built with GCC 4.7 and Linux kernel 3.8.1. LFS-7.4 moved to GCC
4.8.1 and kernel 3.10.10. GCC 4.8 was the first GCC release that dropped the
ability to bootstrap from a plain ISO C89 compiler and started requiring an
existing ISO C++ compiler on the host to build itself. Every earlier GCC
version, including 4.7, could still be bootstrapped with a C compiler alone.
This is a real, load-bearing change to LFS's host-system requirements, not a
cosmetic version bump, and it lands exactly at the 7.3/7.4 boundary that this
repository sits on.

## Provenance

Book content (`book/`) and patches (`patches/`) were pulled from the
project's own repositories at the following commits:

**BLFS book** — `https://git.linuxfromscratch.org/blfs.git`
```
commit 4d6023d2d595288a74f96226c58b2be0cecc70ff (HEAD)
Author: Fernando de Oliveira <fernando@linuxfromscratch.org>
Date:   Sun Aug 4 03:43:23 2013 +0000

    Tag xsane for lfs73_checked, add xscanimage.desktop, add a note for xscanimage

    git-svn-id: svn://svn.linuxfromscratch.org/BLFS/trunk/BOOK@11579 af4574ff-66df-0310-9fd7-8a98e5e911e0
```

**Patches** — `https://github.com/lfs-book/patches`
```
commit 1624c7b86d46ca05ffaf70c7050812100e0badde (HEAD)
Author: Bruce Dubbs <bdubbs@linuxfromscratch.org>
Date:   Sun Aug 4 22:49:07 2013 +0000

    Remove test files

    git-svn-id: svn://svn.linuxfromscratch.org/patches/trunk@2690 5d566035-28df-0310-bceb-a0ef49e0ac98
```

Both commits date to August 4, 2013, the day after Bruce Dubbs' mail above
and eleven days before the announced freeze date. `patches/` contains every
patch referenced by the book at that commit, copied directly from the
patches repository.

Source packages were not vendored into this repository. Instead, `*-links.txt`
files list the original download URL for every package referenced by the
book, and `*.md5` / `*.sha256` files hold the checksums published by the
project for those exact package versions. `build_csv.py` merges each pair of
files into a `*.csv` table (filename, URL, md5, sha256), and
`download_packages.sh` uses those tables to re-fetch and verify the packages.
This keeps the repository reproducible and auditable against the upstream
checksums without redistributing the packages themselves.

## Package tables

Each package group has a rendered table with filenames, download URLs, and
checksums, along with notes on where the packages come from:

- [main-packages.md](main-packages.md) — core BLFS packages
- [perl-packages.md](perl-packages.md) — required Perl modules
- [python-packages.md](python-packages.md) — required Python packages
- [xorg-packages.md](xorg-packages.md) — Xorg packages

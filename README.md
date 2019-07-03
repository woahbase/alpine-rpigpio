[![build status][251]][232] [![commit][255]][231] [![version:armhf][258]][236] [![size:armhf][259]][236] [![version:armv7l][260]][237] [![size:armv7l][261]][237] [![version:aarch64][262]][238] [![size:aarch64][263]][238]

## [Alpine-RPiGPIO][234]
#### Container for Alpine Linux + S6 + Python3 + RPi.GPIO
---

This [image][233] serves as the base image for applications
/ services running on a Raspberrpi Pi 1/2/3 that require GPIO
access, using [RPi.GPIO][137] or serial access using
[PySerial][138], on [Python3][135] and [Pip][136] to manage
dependencies.

Based on [Alpine Linux][131] from my [alpine-s6][132] image with
the [s6][133] init system [overlayed][134] in it.

The image is tagged respectively for the following architectures,
* **armhf**
* **armv7l**
* **aarch64**
* ~~**x86_64** (retagged as the `latest` )~~

**non-x86_64** builds have embedded binfmt_misc support and contain the
[qemu-user-static][105] binary that allows for running it also inside
an x86_64 environment that has it.

---
#### Get the Image
---

Pull the image for your architecture it's already available from
Docker Hub.

```
# make pull
docker pull woahbase/alpine-rpigpio:armhf
```

---
#### Run
---

If you want to run images for other architectures, you will need
to have binfmt support configured for your machine. [**multiarch**][104],
has made it easy for us containing that into a docker container.

```
# make regbinfmt
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

Without the above, you can still run the image that is made for your
architecture, e.g for an armhf machine..

This images already has a user `alpine` configured to drop
privileges to the passed `PUID`/`PGID` which is ideal if its used
to run in non-root mode. That way you only need to specify the
values at runtime and pass the `-u alpine` if need be. (run `id`
in your terminal to see your own `PUID`/`PGID` values.)

Although `--privileged` is not usually required for this image,
you will still need to pass `--device /dev/gpiomem`, and
`--cap-add SYS_RAWIO` to access the gpio, and `--device
/dev/ttyAMA0:/dev/ttyAMA0` for serial access.

Running `make` gets a shell.

```
# make
docker run --rm -it \
  --name docker_rpigpio --hostname rpigpio \
  -e PGID=1001 -e PUID=1001 \
  --device /dev/gpiomem \
  --cap-add SYS_RAWIO \
  --device /dev/ttyAMA0:/dev/ttyAMA0 \
  woahbase/alpine-rpigpio:armhf \
  /bin/bash
```

Stop the container with a timeout, (defaults to 2 seconds)

```
# make stop
docker stop -t 2 docker_rpigpio
```

Removes the container, (always better to stop it first and `-f`
only when needed most)

```
# make rm
docker rm -f docker_rpigpio
```

Restart the container with

```
# make restart
docker restart docker_rpigpio
```

---
#### Shell access
---

Get a shell inside a already running container,

```
# make debug
docker exec -it docker_rpigpio /bin/bash
```

set user or login as root,

```
# make rdebug
docker exec -u root -it docker_rpigpio /bin/bash
```

To check logs of a running container in real time

```
# make logs
docker logs -f docker_rpigpio
```

---
### Development
---

If you have the repository access, you can clone and
build the image yourself for your own system, and can push after.

---
#### Setup
---

Before you clone the [repo][231], you must have [Git][101], [GNU make][102],
and [Docker][103] setup on the machine.

```
git clone https://github.com/woahbase/alpine-rpigpio
cd alpine-rpigpio
```
You can always skip installing **make** but you will have to
type the whole docker commands then instead of using the sweet
make targets.

---
#### Build
---

You need to have binfmt_misc configured in your system to be able
to build images for other architectures.

Otherwise to locally build the image for your system.
[`ARCH` defaults to `x86_64`, need to be explicit when building
for other architectures.]

```
# make ARCH=armhf build
# sets up binfmt if not armhf
docker build --rm --compress --force-rm \
  --no-cache=true --pull \
  -f ./Dockerfile_armhf \
  --build-arg DOCKERSRC=woahbase/alpine-python3:x86_64 \
  --build-arg PGID=1001 \
  --build-arg PUID=1001 \
  -t woahbase/alpine-rpigpio:armhf \
  .
```

To check if its working..

```
# make ARCH=armhf test
docker run --rm -it \
  --name docker_rpigpio --hostname rpigpio \
  -e PGID=1001 -e PUID=1001 \
  woahbase/alpine-rpigpio:armhf \
  sh -ec 'python --version; pip --version; gpio -h'
```

And finally, if you have push access,

```
# make ARCH=armhf push
docker push woahbase/alpine-rpigpio:armhf
```

---
### Maintenance
---

Sources at [Github][106]. Built at [Travis-CI.org][107] (armhf / x64 builds). Images at [Docker hub][108]. Metadata at [Microbadger][109].

Maintained by [WOAHBase][204].

[101]: https://git-scm.com
[102]: https://www.gnu.org/software/make/
[103]: https://www.docker.com
[104]: https://hub.docker.com/r/multiarch/qemu-user-static/
[105]: https://github.com/multiarch/qemu-user-static/releases/
[106]: https://github.com/
[107]: https://travis-ci.org/
[108]: https://hub.docker.com/
[109]: https://microbadger.com/

[131]: https://alpinelinux.org/
[132]: https://hub.docker.com/r/woahbase/alpine-python3
[133]: https://skarnet.org/software/s6/
[134]: https://github.com/just-containers/s6-overlay
[135]: https://www.python.org/
[136]: https://pypi.python.org/pypi/pip
[137]: https://pypi.python.org/pypi/RPi.GPIO
[138]: https://github.com/pyserial/pyserial

[201]: https://github.com/woahbase
[202]: https://travis-ci.org/woahbase/
[203]: https://hub.docker.com/u/woahbase
[204]: https://woahbase.online/

[231]: https://github.com/woahbase/alpine-rpigpio
[232]: https://travis-ci.org/woahbase/alpine-rpigpio
[233]: https://hub.docker.com/r/woahbase/alpine-rpigpio
[234]: https://woahbase.online/#/images/alpine-rpigpio
[235]: https://microbadger.com/images/woahbase/alpine-rpigpio:x86_64
[236]: https://microbadger.com/images/woahbase/alpine-rpigpio:armhf
[237]: https://microbadger.com/images/woahbase/alpine-rpigpio:armv7l
[238]: https://microbadger.com/images/woahbase/alpine-rpigpio:aarch64

[251]: https://travis-ci.org/woahbase/alpine-rpigpio.svg?branch=master

[255]: https://images.microbadger.com/badges/commit/woahbase/alpine-rpigpio.svg

[256]: https://images.microbadger.com/badges/version/woahbase/alpine-rpigpio:x86_64.svg
[257]: https://images.microbadger.com/badges/image/woahbase/alpine-rpigpio:x86_64.svg

[258]: https://images.microbadger.com/badges/version/woahbase/alpine-rpigpio:armhf.svg
[259]: https://images.microbadger.com/badges/image/woahbase/alpine-rpigpio:armhf.svg

[260]: https://images.microbadger.com/badges/version/woahbase/alpine-rpigpio:armv7l.svg
[261]: https://images.microbadger.com/badges/image/woahbase/alpine-rpigpio:armv7l.svg

[262]: https://images.microbadger.com/badges/version/woahbase/alpine-rpigpio:aarch64.svg
[263]: https://images.microbadger.com/badges/image/woahbase/alpine-rpigpio:aarch64.svg

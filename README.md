# Canvas

![](https://img.shields.io/badge/code%20style-black-000000.svg)
![](https://img.shields.io/github/repo-size/wolfgangwazzlestrauss/canvas)
![](https://img.shields.io/github/license/wolfgangwazzlestrauss/canvas)

---

<!-- prettier-ignore -->
**Docker Hub**: https://hub.docker.com/repository/docker/wolfgangwazzlestrauss/canvas

**Source Code**: https://github.com/wolfgangwazzlestrauss/cloudpath

---

[Canvas](https://wolfgangwazzlestrauss.github.io/canvas) is a set of Docker
image tags designed to support development in containers. Each tag contains
distinct set of development features or is a combination of other tags. The
current tags are

- all
- csharp
- go
- python
- rust
- slim
- typescript
- vscode

The latest version of each tag has a Docker Hub path of
`wolfgangwazzlestrauss/canvas:<tag>` or a version path
`wolfgangwazzlestrauss/canvas:<version>-<tag>` except for the `all` tag. It has
respective paths `wolfgangwazzlestrauss/canvas:latest` and
`wolfgangwazzlestrauss/canvas:<version>`.

## Getting Started

### Installation

Canvas can be installed by pulling the Docker image.

```bash
docker pull wolfgangwazzlestrauss/canvas:latest
```

### Usage

Each Canvas image expects to use `/home/canvas/host` as a volume mount to the
user's `$HOME` folder.

```yaml
version: "3.3"
services:
  canvas:
    container_name: canvas
    command: bash
    image: wolfgangwazzlestrauss/canvas:latest
    ports:
      - "8000:8000"
      - "9765:9765"
    restart: always
    tty: true
    volumes:
      - "./:/home/canvas/host"
```

For working with self-signed certificates see
https://github.com/FiloSottile/mkcert.

## Contributing

## License

Licensed under the [MIT](license.txt) license.

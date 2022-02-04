# Canvas

![](https://img.shields.io/badge/code%20style-black-000000.svg)
![](https://img.shields.io/github/repo-size/scruffaluff/canvas)
![](https://img.shields.io/github/license/scruffaluff/canvas)

---

<!-- prettier-ignore -->
**Docker Hub**: https://hub.docker.com/repository/docker/scruffaluff/canvas

**Source Code**: https://github.com/scruffaluff/canvas

---

[Canvas](https://scruffaluff.github.io/canvas) is a set of Docker image tags
designed to support development in containers. Each tag contains distinct set of
development features or is a combination of other tags. The current tags are

- all
- csharp
- go
- python
- rust
- slim
- typescript
- vscode

The latest version of each tag has a Docker Hub path of
`scruffaluff/canvas:<tag>` or a version path
`scruffaluff/canvas:<version>-<tag>` except for the `all` tag. It has respective
paths `scruffaluff/canvas:latest` and `scruffaluff/canvas:<version>`.

## Getting Started

### Installation

Canvas can be installed by pulling the Docker image.

```bash
docker pull scruffaluff/canvas:latest
```

### Usage

Each Canvas image expects to use `/home/canvas/host` as a volume mount to the
user's `$HOME` folder.

Canvas can avoid UID permission errors on Linux by explicitly passing it your
user UID with `-u=<uid>:<uid>` in the command line or setting
`user: <uid>:<uid>` in a compose file.

The following compose file exposes the expected ports, solves Linux UID errors
for Linux user 1005, and mounts the user's home directory.

```yaml
version: "3.3"
services:
  canvas:
    container_name: canvas
    command: bash
    image: scruffaluff/canvas:latest
    ports:
      - "8080:8080"
      - "9765:9765"
    restart: always
    tty: true
    user: "1005:1005"
    volumes:
      - "./:/home/canvas/host"
```

### VSCode

Canvas tags following the formats `latest`, `<version>`, `vscode`, and
`<version>-vscode` have built-in VSCode servers with
[Code Server](https://github.com/cdr/code-server).

To run a HTTP VSCode server change the Docker command to

```console
code-server --bind-addr=0.0.0.0:9765
```

To run a HTTPS VSCode server with existing TLS certificates signed by a CA,
change the Docker command to

```console
code-server --bind-addr=0.0.0.0:9765 --cert=<cert_path> --cert-key=<key_path>
```

For working with self-signed certificates see
[mkcert](https://github.com/FiloSottile/mkcert).

## Contributing

## License

Licensed under the [MIT](license.txt) license.

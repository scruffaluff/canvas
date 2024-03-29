"""Script for building images and running containers with Docker."""


import enum
import pathlib
import re
import subprocess
from typing import List, Tuple

import toml
import typer


class Tag(enum.Enum):
    """Tag options for Canvas images."""

    ALL = "all"
    CSHARP = "csharp"
    GO = "go"
    LEAN = "lean"
    PYTHON = "python"
    RUST = "rust"
    SLIM = "slim"
    TYPESCRIPT = "typescript"
    VSCODE = "vscode"


app = typer.Typer(help=__doc__)


@app.command()
def build(tags: List[Tag]) -> None:
    """Build image TAGS from project Dockerfile."""

    fmt_str = '--build-arg {}_build="true"'

    for tag in tags:
        if tag == Tag.ALL:
            args = [
                fmt_str.format(tag.value)
                for tag in Tag
                if tag not in [Tag.ALL, Tag.SLIM]
            ] + [fmt_str.format("vscode")]
        else:
            args = [fmt_str.format(tag.value)]

        build_args = " ".join(args)
        _, latest = image_name(tag)

        cmd = f"docker build -t {latest} . {build_args}"
        msg = "Failed to build Docker image."
        shell(cmd, msg)


def image_name(tag: Tag) -> Tuple[str, str]:
    """Create Docker image name with tag.

    Args:
        tag: Canvas image tag name.

    Returns:
        Full image name for DockerHub and latest tag name.
    """

    prefix = "scruffaluff/canvas:{}"
    if tag == Tag.ALL:
        return prefix.format(version()), prefix.format("latest")
    else:
        return prefix.format(f"{version()}-{tag.value}"), prefix.format(
            tag.value
        )


@app.command()
def push(tags: List[Tag]) -> None:
    """Push Docker image TAGS to DockerHub."""

    for tag in tags:
        _, latest = image_name(tag)

        tag_cmd = f"docker push {latest}"
        tag_msg = "Failed to push Docker image tag."
        shell(tag_cmd, tag_msg)


@app.command()
def run(tags: List[Tag]) -> None:
    """Run project Docker image TAGS."""

    for tag in tags:
        image, latest = image_name(tag)

        match = re.match(r"^.*:(\w+)$", latest)
        if match is None:
            typer.secho("Error: Invalid full tag name.")
            raise typer.Exit(1)
        else:
            name = f"canvas-{match.group(1)}"

        ports = '-p "9765:9765"' if tag == Tag.VSCODE else ""
        volumes = f"-v {pathlib.Path.home()}:/home/canvas/host"
        args = f"run -dit {ports} {volumes} --rm --name {name}"
        command = f"docker {args} {latest} fish"
        error_msg = "Failed to run Docker container."
        shell(command, error_msg)


def shell(command: str, error_msg: str) -> None:
    """Run shell command and print error message on failure.

    Args:
        command: Command to execute after preparing documentation.
        error_msg: Error message if command fails.
    """

    try:
        subprocess.run(args=command, shell=True, check=True)
    except subprocess.CalledProcessError:
        typer.secho(f"Error: {error_msg}", fg=typer.colors.RED, err=True)
        raise typer.Exit(1)


def version() -> str:
    """Get project version from pyproject.toml file.

    Returns:
        Project version.
    """

    pyproject_path = pathlib.Path(__file__).parents[1] / "pyproject.toml"
    return toml.load(pyproject_path)["tool"]["poetry"]["version"]


if __name__ == "__main__":
    app()

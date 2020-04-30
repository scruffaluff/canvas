"""Script for building images and running containers with Docker."""


import pathlib
import re
import subprocess
from typing import List, Tuple

import typer

import canvas
from canvas.typing import Tag


app = typer.Typer(
    help="Script for building images and running containers with Docker."
)


@app.command()
def build(tags: List[Tag]) -> None:
    """Build image TAGS from project Dockerfile."""
    fmt_str = '--build-arg {}_build="true"'

    for tag in tags:
        if tag == Tag.ALL:
            args = [
                fmt_str.format(tag.value.upper())
                for tag in Tag
                if tag not in [Tag.ALL, Tag.SLIM]
            ]
        else:
            args = [fmt_str.format(tag.value)]

        build_args = " ".join(args)
        image, latest = image_name(tag)

        img_cmd = f"docker build -t {image} . {build_args}"
        img_msg = f"Failed to build Docker image."
        run_command(img_cmd, img_msg)

        tag_cmd = f"docker tag {image} {latest}"
        tag_msg = f"Failed to tag Docker image."
        run_command(tag_cmd, tag_msg)


def image_name(tag: Tag) -> Tuple[str, str]:
    """Create Docker image name with tag.

    Args:
        tag: Canvas image tag name.

    Returns:
        Full image name for DockerHub and latest tag name.
    """
    version = canvas.__version__

    prefix = "wolfgangwazzlestrauss/canvas:{}"
    if tag == Tag.ALL:
        return prefix.format(version), prefix.format("latest")
    else:
        return prefix.format(f"{version}-{tag.value}"), prefix.format(tag.value)


@app.command()
def prune() -> None:
    """Prune all containers and images on system."""
    error_msg = "Failed to prune system."
    run_command("docker system prune -f", error_msg)


def run_command(command: str, error_msg: str) -> None:
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


@app.command()
def push(tags: List[Tag]) -> None:
    """Push Docker image TAGS to DockerHub."""
    for tag in tags:
        image, latest = image_name(tag)

        img_cmd = f"docker push {image}"
        img_msg = "Failed to push Docker image."
        run_command(img_cmd, img_msg)

        tag_cmd = f"docker push {latest}"
        tag_msg = "Failed to push Docker image tag."
        run_command(tag_cmd, tag_msg)


@app.command()
def run(
    tags: List[Tag],
    ports: List[int] = typer.Option([], help="Ports to expose."),
) -> None:
    """Run project Docker image TAGS."""
    for tag in tags:
        image, full_tag = image_name(tag)

        match = re.match(r"^.*:(\w+)$", full_tag)
        if match is None:
            typer.secho("Error: Invalid full tag name.")
            raise typer.Exit(1)
        else:
            name = f"canvas-{match.group(1)}"

        volume = f"{pathlib.Path.home()}:/home/canvas/host"
        command = f"docker run -dit -v {volume} --rm --name {name} {image} zsh"
        error_msg = "Failed to run Docker container."
        run_command(command, error_msg)


if __name__ == "__main__":
    app()

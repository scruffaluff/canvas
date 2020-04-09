"""Script for building images and running containers with Docker."""


import pathlib
import subprocess

import toml
import typer

from canvas.typing import Tag


app = typer.Typer(
    help="Script for building images and running containers with Docker."
)


@app.command()
def build(tag: Tag) -> None:
    """Build image from project Dockerfile."""
    fmt_str = '--build-arg {}_BUILD="TRUE"'

    if tag == Tag.ALL:
        args = [
            fmt_str.format(tag.value.upper())
            for tag in Tag
            if tag not in [Tag.ALL, Tag.SLIM]
        ]
    elif tag == Tag.SLIM:
        args = []
    else:
        args = [fmt_str.format(tag.value.upper())]

    build_args = " ".join(args)
    command = f"docker build -t {image_name(tag)} . {build_args}"
    error_msg = f"Failed to build Docker image."

    run_command(command, error_msg)


def image_name(tag: Tag):
    """Create Docker image name with tag.

    Args:
        tag: Canvas tag name.

    Returns:
        Full image name for DockerHub.
    """
    pyproject_path = pathlib.Path(__file__).parents[1] / "pyproject.toml"
    version = toml.load(pyproject_path)["tool"]["poetry"]["version"]

    if tag == Tag.ALL:
        return f"wolfgangwazzlestrauss/canvas:{version}"
    else:
        return f"wolfgangwazzlestrauss/canvas:{version}-{tag.value}"


@app.command()
def prune() -> None:
    """Prune all containers and images on system."""
    error_msg = "Failed to prune system {}."

    run_command("docker container prune -f", error_msg.format("containers"))
    run_command("docker image prune -f", error_msg.format("images"))


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
def push(tag: Tag) -> None:
    """Run project Docker image."""
    command = f"docker push {image_name(tag)}"

    error_msg = "Faicled to push Docker image."
    run_command(command, error_msg)


@app.command()
def run(tag: Tag, ports) -> None:
    """Run project Docker image."""
    command = f"docker run -dit --rm --name  {image_name(tag)} bash"
    error_msg = "Failed to run Docker container."
    run_command(command, error_msg)


if __name__ == "__main__":
    app()

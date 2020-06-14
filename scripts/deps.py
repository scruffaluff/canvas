"""Script for checking and updating package dependencies."""


import pathlib
from typing import Any, Dict, List

import requests
import toml
import typer


app = typer.Typer(help=__doc__)


# Mypy incorrectly thinks that toml.TomlEncoder is not defined.
class CustomEncoder(toml.TomlEncoder):  # type: ignore
    """Custom TOML encoder that does not use trailing commas."""

    def dump_list(self, list_: List[Any]) -> str:
        """Format list as string without trailing commas.

        Args:
            list_: List to format.

        Returns:
            Formatted list.
        """

        elems = ",".join(str(self.dump_value(elem)) for elem in list_)
        return f"[{elems}]"


def latest(session: requests.Session, package: str) -> str:
    """Find latest version of package on PyPI.

    Args:
        package: Python package name.

    Returns:
        Latest package version.
    """

    endpoint = f"https://pypi.org/pypi/{package}/json"
    with session.get(endpoint) as resp:
        json = resp.json()

    return f"^{json['info']['version']}"


def update(packages: Dict[str, str]) -> None:
    """Mutate dictionary of packages to contain latest version requirements.

    Args:
        packages: Package dictionary to update.
    """

    session = requests.Session()
    for package, current in packages.items():
        if package == "python":
            continue

        latest_ = latest(session, package)
        if current != latest_:
            print(f"updating {package}: {current} -> {latest_}")
            packages[package] = latest_


@app.command()
def main(
    dry_run: bool = typer.Option(
        False, help="Show dependencies that would be updated but do not write."
    )
) -> None:
    """Update pyproject.toml to use latest package dependencies."""

    file_path = pathlib.Path(__file__).parents[1] / "pyproject.toml"
    with open(file_path, "r") as handle:
        config = toml.load(handle)

    update(config["tool"]["poetry"]["dependencies"])
    update(config["tool"]["poetry"]["dev-dependencies"])

    if not dry_run:
        with open(file_path, "w") as handle:
            # Mypy incorrectly thinks that toml.dump can only take 2 arguments.
            toml.dump(config, handle, CustomEncoder())  # type: ignore


if __name__ == "__main__":
    app()

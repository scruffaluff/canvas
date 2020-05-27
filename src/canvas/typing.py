"""Library types for Canvas."""


import enum


class Tag(enum.Enum):
    """Tag options for Canvas images."""

    ALL = "all"
    CSHARP = "csharp"
    CPP = "cpp"
    GO = "go"
    HASKELL = "haskell"
    PYTHON = "python"
    RUST = "rust"
    SLIM = "slim"
    TYPESCRIPT = "typescript"

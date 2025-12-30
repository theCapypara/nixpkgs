import subprocess


def run_command(cmd: list[str], **kwargs) -> str:
    result = subprocess.run(cmd, capture_output=True, check=True, text=True, **kwargs)
    return result.stdout.strip()

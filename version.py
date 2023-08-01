#!/usr/bin/env python3

# Copyright 2019-2023 Outy Business

import argparse
import os
import sys


VERSION = "0.0.1"
PREVIOUS_VERSION = "0.0.0"


PRODUCT_NAME = "Smart Consulant"
YEAR = "2023"
REVISION_LETTER = ""
UPDATE = "1"


SELF_DIR = os.path.dirname(os.path.abspath(__file__))


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Outputs tab separated version information. "
        'The format looks like "Smart Consultant\\t2023 Update 1\\t0.0.1" '
        "i.e. ProductName, YearAndUpdateNumber, SoftwareVersion"
    )
    parser.add_argument("-o", "--output", metavar="<path>")
    args = parser.parse_args(argv)
    software_version = VERSION
    version = f"{PRODUCT_NAME}\t{YEAR}{REVISION_LETTER}\t{UPDATE}\t{software_version}"

    if args.output:
        try:
            with open(args.output, "r") as fp:
                old_version = fp.read().strip()
        except FileNotFoundError:
            old_version = None
        if version != old_version:
            with open(args.output, "w") as fp:
                fp.write(version)
    else:
        print(version)


if __name__ == "__main__":
    sys.exit(main() or 0)

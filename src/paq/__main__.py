import argparse
import os
from rich_argparse import RawDescriptionRichHelpFormatter
import sys
from paq import (
    PaqConf,
    ConfInstall,
    ConfRemove,
    OnlinePackage,
    InstalledPackage,
    __version__,
)
from rich.console import Console
from rich.columns import Columns
from rich.panel import Panel

console = Console(tab_size=4)

if not sys.warnoptions and os.getenv("DEBUG", None) is not None:
    import warnings

    warnings.simplefilter("ignore")


def handler_config_get(conf: PaqConf, args: argparse.Namespace):
    console.print(conf.get(args.key[0]))


def handler_config_set(conf: PaqConf, args: argparse.Namespace):
    conf.set(args.key[0], args.value[0])
    conf.save()
    console.print_json('{"' + args.key[0] + '": "' + args.value[0] + '"}')


def handler_install(conf: PaqConf, args: argparse.Namespace):
    conf.bin_dir = args.bin_dir[0]
    conf.install_dir = args.install_dir[0]
    no_failed_install = False
    if len(args.packages) == 0:
        args.packages = list(
            map(lambda x: x.name, InstalledPackage.get_all_packages())
        )
        no_failed_install = True
    packages = OnlinePackage.get_all_packages(queries=args.packages)
    pacakages_to_install = filter(lambda p: p.name in args.packages, packages)
    for package in pacakages_to_install:
        error = False
        try:
            package.install(
                console,
                ConfInstall(
                    conf.install_dir,
                    conf.bin_dir,
                    args.update,
                    no_failed_install,
                ),
            )
        except Exception:
            console.print_exception()
            error = True
        paq_install = InstalledPackage.add_package(package.name)
        if error:
            paq_install.remove_package(
                ConfRemove(conf.install_dir, conf.bin_dir)
            )


def handler_update(conf: PaqConf, args: argparse.Namespace):
    args.update = True
    handler_install(conf, args)


def handler_uninstall(conf: PaqConf, args: argparse.Namespace):
    if len(args.packages) == 0:
        console.print("[red]Need atleast 1 package to uninstall")
        return
    conf.bin_dir = args.bin_dir[0]
    conf.install_dir = args.install_dir[0]
    packages = InstalledPackage.get_all_packages()
    pacakages_to_remove = filter(lambda p: p.name in args.packages, packages)
    for package in pacakages_to_remove:
        package.remove_package(ConfRemove(conf.install_dir, conf.bin_dir))


def handler_search(_: PaqConf, args: argparse.Namespace):
    packages = OnlinePackage.get_all_packages(queries=args.query)
    arr = []
    for package in packages:
        s = f"[b]{package.name}[/b]\n[yellow]{package.version}"
        arr.append(Panel(s, expand=True))
    console.print(Columns(arr))


def handler_list(conf: PaqConf, args: argparse.Namespace):
    packages = InstalledPackage.get_all_packages(args.query)
    arr = []
    conf.bin_dir = args.bin_dir[0]
    conf.install_dir = args.install_dir[0]
    confRm = ConfRemove(conf.install_dir, conf.bin_dir)
    for package in packages:
        s = (
            f"[b]{package.get_metadata(confRm).name}[/b]:"
            + f"{package.get_metadata(confRm).version}\n"
            + f"{package.get_metadata(confRm).author} :: "
            + f"{package.get_metadata(confRm).license}\n"
            + f"[link={package.get_metadata(confRm).homepage}]"
            + f"[i][blue]{package.get_metadata(confRm).homepage}[/blue][/i]\n"
            + f"{package.get_metadata(confRm).description}\n"
        )
        arr.append(Panel(s, expand=True))
    console.print(Columns(arr))


def create_parser(conf: PaqConf) -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        formatter_class=RawDescriptionRichHelpFormatter,
        description="Install packages",
    )
    parser.add_argument(
        "--install-dir",
        nargs=1,
        default=[conf.install_dir],
        type=str,
        action="store",
        help="Specify where packages will be installed",
    )
    parser.add_argument(
        "--bin-dir",
        nargs=1,
        default=[conf.bin_dir],
        type=str,
        action="store",
        help="Specify where binaries will be symlinked",
    )
    parser.add_argument(
        "--version",
        default=False,
        action="store_true",
        help="Specify where binaries will be symlinked",
    )
    parser.set_defaults(func=lambda conf, args: parser.print_help())
    subparser = parser.add_subparsers()

    parser_config = subparser.add_parser("config")
    subparser_config = parser_config.add_subparsers()
    parser_config_get = subparser_config.add_parser("get")
    parser_config_get.set_defaults(func=handler_config_get)
    parser_config_get.add_argument(
        "key", nargs=1, type=str, action="store", help="Key to get"
    )
    parser_config_set = subparser_config.add_parser("set")
    parser_config_set.set_defaults(func=handler_config_set)
    parser_config_set.add_argument(
        "key", nargs=1, type=str, action="store", help="Key to set"
    )
    parser_config_set.add_argument(
        "value", nargs=1, type=str, action="store", help="Value to set"
    )

    parser_install = subparser.add_parser("install")
    parser_install.set_defaults(func=handler_install)
    parser_install.add_argument(
        "--update",
        action="store_true",
        default=False,
        help="Update existing packages",
    )
    parser_install.add_argument(
        "packages",
        nargs="*",
        type=str,
        action="store",
        help="Packages to install",
    )

    parser_update = subparser.add_parser("update")
    parser_update.set_defaults(func=handler_update)
    parser_update.add_argument(
        "packages",
        nargs="*",
        type=str,
        action="store",
        help="Packages to install",
    )

    parser_uninstall = subparser.add_parser("uninstall")
    parser_uninstall.set_defaults(func=handler_uninstall)
    parser_uninstall.add_argument(
        "packages",
        nargs="*",
        type=str,
        action="store",
        help="Packages to install",
    )

    parser_search = subparser.add_parser("search")
    parser_search.set_defaults(func=handler_search)
    parser_search.add_argument(
        "query",
        nargs="*",
        type=str,
        action="store",
        help="Queries to search (contains)",
    )

    parser_list = subparser.add_parser("list")
    parser_list.set_defaults(func=handler_list)
    parser_list.add_argument(
        "query",
        nargs="*",
        type=str,
        action="store",
        help="Queries to list installed (fnmatch)",
    )

    return parser


def main():
    conf = PaqConf.get_conf()
    parser = create_parser(conf)
    args = parser.parse_args()
    if args.version:
        console.print(f"paq {__version__}")
        return
    args.func(conf, args)


main()

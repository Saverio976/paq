import argparse
import os
import re
from rich_argparse import RawDescriptionRichHelpFormatter
import sys
from paq import PaqConf, ConfInstall, ConfRemove, OnlinePackage, InstalledPackage

if not sys.warnoptions and os.getenv("DEBUG", None) is not None:
    import warnings

    warnings.simplefilter("ignore")


def handler_config_get(conf: PaqConf, args: argparse.Namespace):
    print(conf.get(args.key[0]))


def handler_config_set(conf: PaqConf, args: argparse.Namespace):
    conf.set(args.key[0], args.value[0])
    conf.save()


def handler_install(conf: PaqConf, args: argparse.Namespace):
    conf.bin_dir = args.bin_dir[0]
    conf.install_dir = args.install_dir[0]
    no_failed_install = False
    if len(args.packages) == 0:
        args.packages = list(map(lambda x: x.name, InstalledPackage.get_all_packages()))
        no_failed_install = True
    packages = OnlinePackage.get_all_packages(queries=args.packages)
    pacakages_to_install = filter(lambda p: p.name in args.packages, packages)
    for package in pacakages_to_install:
        error = False
        try:
            package.install(ConfInstall(conf.install_dir, conf.bin_dir, args.update, no_failed_install))
        except Exception as esc:
            print(esc)
            error = True
        paq_install = InstalledPackage.add_package(package.name)
        if error:
            paq_install.remove_package(ConfRemove(conf.install_dir, conf.bin_dir)


def handler_update(conf: PaqConf, args: argparse.Namespace):
    args.update = True
    handler_install(conf, args)


def handler_uninstall(conf: PaqConf, args: argparse.Namespace):
    conf.bin_dir = args.bin_dir[0]
    conf.install_dir = args.install_dir[0]
    packages = InstalledPackage.get_all_packages()
    pacakages_to_remove = filter(lambda p: p.name in args.packages, packages)
    for package in pacakages_to_remove:
        package.remove_package(ConfRemove(conf.install_dir, conf.bin_dir))


def handler_search(_: PaqConf, args: argparse.Namespace):
    packages = OnlinePackage.get_all_packages(queries=args.query)
    for package in packages:
        print(package.name, package.version)


def create_parser(conf: PaqConf) -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        formatter_class=RawDescriptionRichHelpFormatter, description="Install packages"
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
        "--update", action="store_true", default=False, help="Update existing packages"
    )
    parser_install.add_argument(
        "packages", nargs="*", type=str, action="store", help="Packages to install"
    )

    parser_update = subparser.add_parser("update")
    parser_update.set_defaults(func=handler_update)
    parser_update.add_argument(
        "packages", nargs="*", type=str, action="store", help="Packages to install"
    )

    parser_uninstall = subparser.add_parser("uninstall")
    parser_uninstall.set_defaults(func=handler_uninstall)
    parser_uninstall.add_argument(
        "packages", nargs="*", type=str, action="store", help="Packages to install"
    )

    parser_search = subparser.add_parser("search")
    parser_search.set_defaults(func=handler_search)
    parser_search.add_argument(
        "query", nargs="*", type=str, action="store", help="Queries to search (regex)"
    )

    return parser


def main():
    conf = PaqConf.get_conf()
    parser = create_parser(conf)
    args = parser.parse_args()
    args.func(conf, args)


main()

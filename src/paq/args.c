#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "tlcllists.h"
#include "tlcstrings.h"
#include "args.h"

static struct paq_args_s *paq_args_create()
{
    struct paq_args_s *args = calloc(1, sizeof(struct paq_args_s));

    if (!args) {
        return NULL;
    }
    args->type = PAQ_TYPE_ERROR;
    return args;
}

static struct paq_args_s *parse_args_install(struct paq_args_s *args, const int argc, const char *const argv[])
{
    args->type = PAQ_TYPE_INSTALL;
    args->action.install.packages = list_create();

    if (!args->action.install.packages) {
        args->type = PAQ_TYPE_ERROR;
        args->error = "Failed to allocate\n";
        return args;
    }

    for (int i = 2; i < argc; i++) {
        if (x_strstartswith(argv[i], "--")) {
            fprintf(stderr, "%s", "No option for install\n");
        } else {
            list_append(args->action.install.packages, (void *) argv[i], NULL, NULL);
        }
    }
    return args;
}

static struct paq_args_s *parse_args_update(struct paq_args_s *args, const int argc, const char *const argv[])
{
    args->type = PAQ_TYPE_UPDATE;
    args->action.update.repositories = list_create();

    if (!args->action.update.repositories) {
        args->type = PAQ_TYPE_ERROR;
        args->error = "Failed to allocate\n";
        return args;
    }

    for (int i = 2; i < argc; i++) {
        if (x_strstartswith(argv[i], "--")) {
            fprintf(stderr, "%s", "No option for update\n");
        } else {
            list_append(args->action.update.repositories, (void *) argv[i], NULL, NULL);
        }
    }
    return args;
}

static struct paq_args_s *parse_args_upgrade(struct paq_args_s *args, const int argc, const char *const argv[])
{
    args->type = PAQ_TYPE_UPGRADE;
    args->action.upgrade.packages = list_create();

    if (!args->action.upgrade.packages) {
        args->type = PAQ_TYPE_ERROR;
        args->error = "Failed to allocate\n";
        return args;
    }

    for (int i = 2; i < argc; i++) {
        if (x_strstartswith(argv[i], "--")) {
            fprintf(stderr, "%s", "No option for upgrade\n");
        } else {
            list_append(args->action.upgrade.packages, (void *) argv[i], NULL, NULL);
        }
    }
    return args;
}

static struct paq_args_s *parse_args_uninstall(struct paq_args_s *args, const int argc, const char *const argv[])
{
    args->type = PAQ_TYPE_UNINSTALL;
    args->action.uninstall.packages = list_create();

    if (!args->action.uninstall.packages) {
        args->type = PAQ_TYPE_ERROR;
        args->error = "Failed to allocate\n";
        return args;
    }

    for (int i = 2; i < argc; i++) {
        if (x_strstartswith(argv[i], "--")) {
            fprintf(stderr, "%s", "No option for uninstall\n");
        } else {
            list_append(args->action.uninstall.packages, (void *) argv[i], NULL, NULL);
        }
    }
    if (L_LEN(args->action.uninstall.packages) == 0) {
        list_delete(args->action.uninstall.packages);
        args->type = PAQ_TYPE_ERROR;
        args->error = "Need at least one package to uninstall\n";
    }
    return args;
}

static struct paq_args_s *parse_args_config(struct paq_args_s *args, const int argc, const char *const argv[])
{
    args->type = PAQ_TYPE_CONFIG;

    if (argc < 3) {
        args->type = PAQ_TYPE_ERROR;
        args->error = "paq config {set,get}\n";
        return args;
    }

    if (strcmp(argv[2], "get") == 0) {
        if (argc != 4) {
            args->type = PAQ_TYPE_ERROR;
            args->error = "paq config get <key-to-get>\n";
            return args;
        }
        args->action.config.get = true;
        args->action.config.set = false;
        args->action.config.key = argv[3];
        args->action.config.value = NULL;
    } else if (strcmp(argv[2], "set") == 0) {
        if (argc != 5) {
            args->type = PAQ_TYPE_ERROR;
            args->error = "paq config set <ket-to-set> <value>\n";
            return args;
        }
        args->action.config.get = false;
        args->action.config.set = true;
        args->action.config.key = argv[3];
        args->action.config.value = argv[4];
    }
    return args;
}

struct paq_args_s *parse_args(const int argc, const char *const argv[])
{
    struct paq_args_s *args = paq_args_create();

    if (!args) {
        return NULL;
    }
    if (argc < 2) {
        args->type = PAQ_TYPE_ERROR;
        args->error = "paq {install,update,upgrade,uninstall,config}\n";
        return args;
    }
    if (strcmp(argv[1], "install") == 0) {
        args = parse_args_install(args, argc, argv);
    } else if (strcmp(argv[1], "update") == 0) {
        args = parse_args_update(args, argc, argv);
    } else if (strcmp(argv[1], "upgrade") == 0) {
        args = parse_args_upgrade(args, argc, argv);
    } else if (strcmp(argv[1], "uninstall") == 0) {
        args = parse_args_uninstall(args, argc, argv);
    } else if (strcmp(argv[1], "config") == 0) {
        args = parse_args_config(args, argc, argv);
    }
    return args;
}

void destroy_args(struct paq_args_s *args)
{
    if (!args) {
        return;
    }
    if (args->type == PAQ_TYPE_INSTALL) {
        list_delete(args->action.install.packages);
    } else if (args->type == PAQ_TYPE_UPDATE) {
        list_delete(args->action.update.repositories);
    } else if (args->type == PAQ_TYPE_UPGRADE) {
        list_delete(args->action.upgrade.packages);
    } else if (args->type == PAQ_TYPE_UNINSTALL) {
        list_delete(args->action.uninstall.packages);
    } else if (args->type == PAQ_TYPE_CONFIG) {
        //
    }
    free(args);
}

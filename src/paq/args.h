#ifndef PAQ_ARGS_H_
    #define PAQ_ARGS_H_

    #include <stdbool.h>
    #include "tlcllists.h"

enum paq_type_e {
    PAQ_TYPE_INSTALL = 0,
    PAQ_TYPE_UPDATE,
    PAQ_TYPE_UPGRADE,
    PAQ_TYPE_UNINSTALL,
    PAQ_TYPE_CONFIG,
    PAQ_TYPE_ERROR,
};

struct paq_action_install_s {
    list_t *packages;
};

struct paq_action_update_s {
    list_t *repositories;
};

struct paq_action_upgrade_s {
    list_t *packages;
};

struct paq_action_uninstall_s {
    list_t *packages;
};

struct paq_action_config_s {
    bool get;
    bool set;
    const char *key;
    const char *value;
};

struct paq_args_s {
    union {
        struct paq_action_install_s install;
        struct paq_action_update_s update;
        struct paq_action_upgrade_s upgrade;
        struct paq_action_uninstall_s uninstall;
        struct paq_action_config_s config;
    } action;
    enum paq_type_e type;
    const char *error;
};

struct paq_args_s *parse_args(const int argc, const char *const argv[]);

void destroy_args(struct paq_args_s *args);

#endif

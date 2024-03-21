#include <stdio.h>
#include "args.h"

int main(const int argc, const char * const argv[])
{
    struct paq_args_s *args = parse_args(argc, argv);

    if (args->type == PAQ_TYPE_ERROR) {
        if (args->error != NULL) {
            fprintf(stderr, "%s", args->error);
        }
        destroy_args(args);
        return 1;
    }
    destroy_args(args);
    return 0;
}

#ifndef INCLUDED_DEBUGGING_H
#define INCLUDED_DEBUGGING_H

static int known_bp(int iargc)
{
    return iargc;
}

void debug_info(int argc, char **argv)
{
    fprintf(stderr, "%s pid %d\n", argv[0], getpid());

    if (getenv("GO_TO_SLEEP")) {
        sleep(40);
    }

    (void)known_bp(argc);

    for (int i=0; i<argc; i++) {
        fprintf(stderr, "[%d] %s\n", i, argv[i]);
    }
}
#endif


/*
   The organization of this file is modelled after the motorforce example
   developed by Uros Platise.
   Removed windows support
*/
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include "d_process.h"

#define DIGITAL_IN      0
#define DIGITAL_OUT     4

static int compute(uint8_t *dataout, int outsz, double time);

//#define ENABLE_DEBUGGING 1
#ifdef ENABLE_DEBUGGING
#include "debugging.h"
#endif

int main(int argc, char *argv[]) {    
    int i;
    int outlen = D_PROCESS_DLEN(DIGITAL_OUT);

    struct in_s {
        double time;
    } __attribute__((packed)) in;
            
    struct out_s {
        uint8_t dout[D_PROCESS_DLEN(DIGITAL_OUT)];
    } __attribute__((packed)) out;

    int pipein = 0; // default stdin to recv from ngspice
    int pipeout= 1; // default stdout to send to ngspice

#ifdef ENABLE_DEBUGGING
    debug_info(argc, argv);
#endif

    for (i = 0; i <argc; i++) {
        if (strcmp(argv[i],"--pipe")==0) {
            if ((pipein = open("graycode_in",  O_RDONLY)) < 0 || (pipeout = open("graycode_out",  O_WRONLY)) < 0)
            {
                fprintf(stderr, "Cannot open %s named pipes\n", argv[0]);
                return -1;
            }
        }
    }
    
    if (d_process_init(pipein, pipeout, DIGITAL_IN, DIGITAL_OUT) ) {
        while(read(pipein, &in, sizeof(in)) == sizeof(in)) {

            if (!compute(out.dout, outlen, in.time)) {
                return 1;
            }

            write(pipeout, &out, sizeof(out));
        }
        return 0;
    }
    return -1;
}

static int compute(uint8_t *dataout, int outsz, double time)
{
    static uint8_t count = 0;
    if (count < 15) {
        count++;
    } else {
        count = 0;
    }
    dataout[0] = (count ^ (count >> 1)) & 0x0F;
    return 1;
}


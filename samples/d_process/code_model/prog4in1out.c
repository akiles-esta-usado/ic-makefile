/*
   The organization of this file is modelled after the motorforce example
   developed by Uros Platise.
*/
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include "d_process.h"

#define DIGITAL_IN      4
#define DIGITAL_OUT     1

static int compute(
    uint8_t *datain, int insz, uint8_t *dataout, int outsz, double time
);

//#define ENABLE_DEBUGGING 1
#ifdef ENABLE_DEBUGGING
#include "debugging.h"
#endif

int main(int argc, char *argv[]) {    
    int inlen = D_PROCESS_DLEN(DIGITAL_IN);
    int outlen = D_PROCESS_DLEN(DIGITAL_OUT);

    struct in_s {
        double time;
        uint8_t din[D_PROCESS_DLEN(DIGITAL_IN)];
    } __attribute__((packed)) in;
            
    struct out_s {
        uint8_t dout[D_PROCESS_DLEN(DIGITAL_OUT)];
    } __attribute__((packed)) out;

    int pipein = 0; // default stdin to recv from ngspice
    int pipeout= 1; // default stdout to send to ngspice

#ifdef ENABLE_DEBUGGING
    debug_info(argc, argv);
#endif
    
    if (d_process_init(pipein, pipeout, DIGITAL_IN, DIGITAL_OUT) ) {
        while(read(pipein, &in, sizeof(in)) == sizeof(in)) {

            if (!compute(in.din, inlen, out.dout, outlen, in.time)) {
                return 1;
            }

            write(pipeout, &out, sizeof(out));
        }
        return 0;
    }
    return -1;
}

static int compute(
    uint8_t *datain, int insz, uint8_t *dataout, int outsz, double time
)
{
    uint8_t i0 = 0, zeros = 0;
    uint8_t inbyte = datain[0] & 0x0F;
    dataout[0] = 0;
    i0 = inbyte & 0x01;
    if (i0 == 0) zeros++;
    i0 = inbyte & 0x02;
    if (i0 == 0) zeros++;
    i0 = inbyte & 0x04;
    if (i0 == 0) zeros++;
    i0 = inbyte & 0x08;
    if (i0 == 0) zeros++;
    if (zeros == 2 || zeros == 4) {
        dataout[0] = 0x01;
    } else {
        dataout[0] = 0x00;
    }
    fprintf(stderr, "datain %X zeros %d dataout %X time %g\n",
        datain[0], zeros, dataout[0], time);
    return 1;
}



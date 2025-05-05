#include <stdio.h>
#include <stdlib.h>

struct frame {
    int info;
    int seq;
};

int disconnect = 0;
int ack = -1;
int errorFrame = 0, errorAck = 0;
char turn = 's';

struct frame p;

void initializeFrames() {
    p.info = 1;
    p.seq = 0;
}

void sender() {
    if (turn == 's') {
        printf("SENDER: Sent frame %d\n", p.seq);
        errorFrame = rand() % 4;
        if (errorFrame == 0) {
            printf("Error while sending frame %d\n", p.seq);
        }
        turn = 'r';
    }
}

void receiver() {
    if (turn == 'r') {
        if (errorFrame != 0) {
            printf("RECEIVER: Received frame %d\n", p.seq);
            ack = p.seq;
            errorAck = rand() % 4;
            if (errorAck == 0) {
                printf("Error while sending ACK %d\n", ack);
                turn = 's'; // Resend same frame
            } else {
                p.seq++;
                p.info++;
                if (p.seq == 5) disconnect = 1;
                turn = 's';
            }
        }
    }
}

int main() {
    initializeFrames();
    while (!disconnect) {
        sender();
        receiver();
    }
    return 0;
}

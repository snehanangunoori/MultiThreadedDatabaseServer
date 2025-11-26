CFLAGS = -Wall -Werror -std=gnu99

all: dbserver dbclient

clean:
	rm -f dbserver dbclient

dbserver: dbserver.c msg.h
	gcc dbserver.c -o dbserver $(CFLAGS) -pthread

dbclient: dbclient.c msg.h
	gcc dbclient.c -o dbclient $(CFLAGS)

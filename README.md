# Multi-Threaded Database Server

A simple multi-threaded TCP database server and interactive client written in C.
Built for learning UNIX systems programming, sockets, and multithreading.

## 🚀 Overview

This project implements:

- **dbserver** — a multi-threaded database server using TCP sockets + pthreads
- **dbclient** — an interactive client that sends PUT and GET operations
- **msg.h** — a shared binary protocol for communication

The server stores fixed-size records in a simple file-based database (`mydb.txt`).
Each client is handled in its own thread, allowing many clients to run at the same time.

## 📌 Features

### Server (`dbserver`)
- Accepts unlimited concurrent clients
- Thread-per-connection design using `pthread_create()` and `pthread_detach()`
- Supports:
  - **PUT** — store a record (name + id)
  - **GET** — retrieve a record by id
- Fixed 256-byte record format for predictable file offsets
- Each thread separately opens the database file
- Prints client connection info for debugging

### Client (`dbclient`)
- Interactive command-line tool
- Sends structured messages using the protocol in `msg.h`
- Supports:
  - `1` → PUT
  - `2` → GET
  - `0` → QUIT
- Displays server responses (SUCCESS or FAIL)

## 📁 File Structure

```text
├── dbserver.c    # Multi-threaded database server
├── dbclient.c    # Interactive client program
├── msg.h         # Protocol definitions
├── Makefile      # Build rules
└── mydb.txt      # Runtime database file
```

## 🛠️ Building

**Build all targets:**
```sh
make
```

**Build individually:**
```sh
make dbserver
make dbclient
```

**Clean:**
```sh
make clean
```

## ▶️ Running

### Start the server
```sh
./dbserver <port>
```
*Example:*
```sh
./dbserver 3648
```

### Start the client
```sh
./dbclient <hostname> <port>
```
*Example:*
```sh
./dbclient localhost 3648
```

## 🔌 Message Protocol (msg.h)

### Types
```c
#define PUT     1
#define GET     2
#define SUCCESS 4
#define FAIL    5
```

### Record Structure (256 bytes)
```c
struct record {
    char name[128];
    uint32_t id;
    char pad[124];
};
```

### Message Structure
```c
struct msg {
    uint8_t type;
    struct record rd;
};
```

## 🧠 Internal Design Summary

1. **Server binds** to a port and listens for clients.
2. **Each client connection** spawns a dedicated handler thread.
3. **Each thread**:
   - Reads a `msg` from the client.
   - Executes:
     - **PUT** → seek to `id * sizeof(record)` and write.
     - **GET** → seek to same offset and read.
   - Sends back `SUCCESS`/`FAIL` responses.
4. **Client** uses a simple menu to send PUT or GET requests.

## 🎓 Credits

This project was developed for **CS 3377 (UNIX Systems Programming)** at **UT Dallas**, taught by **Professor Alagar**.

> The project demonstrates systems-level concepts: networking, concurrency, file I/O, and binary protocols in C.

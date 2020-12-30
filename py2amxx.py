#! /usr/bin/env python
# -*- coding:utf-8 -*-
# version : Python 2.7.13

import socket
import threading


def listen_to_client(client):
    size = 1024
    while True:
        try:
            data = client.recv(size)
            if data:
                response = data
                client.send(response)
                # print("secndLen: ", len(data))
                print(data.decode())
            else:
                raise Exception('Client disconnected')
        except Exception as e:
            print(repr(e))
            client.close()
            return False


class ThreadedServer(object):
    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.sock.bind((self.host, self.port))

    def listen(self):
        self.sock.listen(5)
        while True:
            client, address = self.sock.accept()
            client.settimeout(60)
            threading.Thread(target=listen_to_client, args=(client,)).start()


if __name__ == "__main__":
    while True:
        port_num = 54500
        try:
            port_num = int(port_num)
            break
        except ValueError:
            pass

    ThreadedServer('127.0.0.1', port_num).listen()

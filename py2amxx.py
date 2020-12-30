import socket

host = ''
port = 54500

s = socket.socket()
s.bind((host, port))

s.listen(32)


while True:
    conn, address = s.accept()
    print("Connection from: " + str(address))
    try:
        while True:
            data = conn.recv(256).decode()
            if not data:
                break
            print("from connected user: " + str(data))
            # data = input(" -> ")
            # conn.send(data.encode())
    except Exception as e:
        print(repr(e))
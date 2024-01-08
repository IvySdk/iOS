#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import sys, base64
from Crypto.Cipher import AES

def encrypt(data, password, iv):
    bs = AES.block_size
    pad = lambda s: s + (bs - len(s) % bs) * chr(bs - len(s) % bs)
    cipher = AES.new(password, AES.MODE_CBC, iv)
    data = cipher.encrypt(pad(data))
    return data


def decrypt(data, password, iv):
    unpad = lambda s: s[0:-ord(s[-1])]
    cipher = AES.new(password, AES.MODE_CBC, iv)
    data = unpad(cipher.decrypt(data))
    return data


def main(argv):
    op = argv[0]
    iv = '0000000000000000'
    key = '66e3d50482fb2b467642a858af7574ee'
    in_file = open(argv[1], 'r')
    out_file = open(argv[2], 'w')
    if op == 'e':
        encrypt_data = encrypt(in_file.read(), key, iv)
        encrypt_data = base64.urlsafe_b64encode(encrypt_data)
        print encrypt_data
        out_file.write(encrypt_data)

    elif op == 'd':
        encrypt_data = in_file.read()
        encrypt_data = base64.urlsafe_b64decode(encrypt_data)
        decrypt_data = decrypt(encrypt_data, key, iv)
        print decrypt_data
        out_file.write(decrypt_data)

    in_file.close()
    out_file.close()


if __name__ == '__main__':
    main(sys.argv[1:])

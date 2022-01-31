# ISS-CW2

## TODO:
- ☑ Have meeting
- ☐ Create internal network (Figure A)
- ☐ Create untrusted hotel network (Figure B)
- ☐ Setup root CA Cert
- ☐ Setup VPNs
- ☐ Setup 

## Resources:

- [Creating x509 root certificate authority](https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/)
- [Setting up StrongSwan vpn (Server and client)](https://www.digitalocean.com/community/tutorials/how-to-set-up-wireguard-on-ubuntu-20-04)
- [Setting up Wireguard vpn (server and client)](https://www.digitalocean.com/community/tutorials/how-to-set-up-wireguard-on-ubuntu-20-04)

## Figures:

### Figure A:

```
                    ┌─────────────┐
                    │             │
                    │ Strong Swan │
                ┌───┤     VPN     │
┌──────────┐    │   │             │
│          │    │   └─────────────┘
│ Internet ├────┤
│          │    │    ┌───────────┐
└──────────┘    │    │           │
                └────┤ Wireguard │
                     │    VPN    │
                     │           │
                     └───────────┘
```

### Figure B:

```
                   ┌─────────┐      ┌──────────┐
                   │         │      │          │
               ┌───┤ Hotel A ├──────┤ Employee │
               │   │         │      │          │
┌──────────┐   │   └─────────┘      └──────────┘
│          │   │
│ Internet ├───┤                   (VPN Clients)
│          │   │
└──────────┘   │   ┌─────────┐      ┌──────────┐
               │   │         │      │          │
               └───┤ Hotel B ├──────┤ Employee │
                   │         │      │          │
                   └─────────┘      └──────────┘
```
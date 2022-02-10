# ISS-CW2

## TODO:

### Phase 1:
- ☑ Have meeting
- ☐ Create internal network (Figure A)
- ☐ Create untrusted hotel network (Figure B)
- ☐ Setup root CA Cert
- ☐ Setup VPNs

### Phase 2:
- ☐ Make sure config files are clean and well documented
- ☐ Sign GPG keys etc.
- ☐ Make case for scalability of CA structure

### Phase 3:
- ☐ Implement HTTPS apache web server (First resource covers this)
- ☐ Put signed keys on key servers
- ☐ Justify configuration choices etc.

## Resources:

- [Creating x509 root certificate authority](https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/)
- [Setting up StrongSwan vpn (Server and client)](https://www.digitalocean.com/community/tutorials/how-to-set-up-wireguard-on-ubuntu-20-04)
- [Setting up WireGuard vpn (server and client)](https://www.digitalocean.com/community/tutorials/how-to-set-up-wireguard-on-ubuntu-20-04)

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